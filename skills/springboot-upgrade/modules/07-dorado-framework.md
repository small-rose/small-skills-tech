# 专有框架迁移指南（以 Dorado 7 为例）

> **适用场景**: 传统 Spring MVC 项目使用 Dorado、Vaadin、ZK、GWT 等专有 RIA 框架时，
> 升级到 Spring Boot 需要解决的框架兼容性问题。
>
> 本指南以 **Dorado 7**（`dorado-core-7.4.1`）为例，总结专有框架迁移到 Spring Boot 的
> 通用方法论和具体技术方案。

---

## 1. 专有框架升级的核心矛盾

传统部署（WAR + 外部容器）下专有框架的初始化链路:

```
容器启动
  ├─ web.xml → ContextLoaderListener → Spring ROOT Context
  ├─ web.xml → 专有框架 Servlet.init()
  │    └─ 读取 web.xml init-param / ServletContext init-parameter
  │    └─ 加载框架自身的 Context（多个 XML 配置文件）
  │    └─ 设置框架全局状态（如 failSafeContext）
  └─ web.xml → Servlet URL 映射 → 处理请求
```

Spring Boot 嵌入式 Tomcat 下断裂的链路:

```
Spring Boot 启动
  ├─ 无 web.xml → 专有框架 Servlet 未注册            ← 断裂①
  ├─ 无 ContextLoaderListener → 框架 Context 未加载    ← 断裂②
  ├─ 无 Servlet.init() → 框架全局状态未初始化          ← 断裂③
  └─ 无 Servlet URL 映射 → 请求 404                    ← 断裂④
```

---

## 2. 迁移四步法

| 步骤 | 解决断裂 | 技术手段 | 优先级 |
|:----:|:--------:|---------|:------:|
| 1 | ④ URL 映射 | `ServletRegistrationBean` 注册 FrameworkServlet | P0 |
| 2 | ② Context 加载 | `@ImportResource` 按依赖序加载框架 XML | P0 |
| 3 | ③ 全局状态 | `ServletContextInitializer` 初始化框架上下文 | P1 |
| 4 | ① 子 Context | 框架 Servlet 的子 Context 配置加载（Configure/存储层） | P1 |

---

## 3. 步骤一：Servlet 注册

所有专有框架的 Servlet 都必须通过 `ServletRegistrationBean` 注册。

### 3.1 基本注册

```java
@Configuration
public class DoradoConfig {
    @Bean
    public ServletRegistrationBean<DoradoServlet> doradoServlet() {
        ServletRegistrationBean<DoradoServlet> bean =
                new ServletRegistrationBean<>(new DoradoServlet());
        bean.addUrlMappings("*.d", "*.do", "*.c", "*.dpkg", "/dorado/*");
        bean.setLoadOnStartup(1);
        bean.setName("doradoServlet");  // 与 web.xml <servlet-name> 一致
        return bean;
    }
}
```

### 3.2 WAR 共存策略

`setName("doradoServlet")` 必须与 `web.xml` 中的 `<servlet-name>` 一致。

WAR 部署到外部 Tomcat 时:
1. Tomcat 先处理 `web.xml` → 注册 `doradoServlet`
2. Spring Boot 的 `ServletContextInitializer` → 调用 `servletContext.addServlet("doradoServlet", ...)`
3. `addServlet()` 发现名称已存在 → 返回已存在的 `ServletRegistration.Dynamic` → 更新 URL 映射
4. **不冲突，不重复注册**

### 3.3 Filter 注册与顺序

```java
@Bean
public FilterRegistrationBean<DelegatingFilterProxy> delegatingFilterProxy() {
    FilterRegistrationBean<DelegatingFilterProxy> bean =
            new FilterRegistrationBean<>(new DelegatingFilterProxy());
    bean.addUrlPatterns("/*");
    bean.setOrder(1);       // 值越小优先级越高
    bean.setName("delegatingFilterProxy");
    return bean;
}

@Bean
public FilterRegistrationBean<LoginFilter> loginFilter() {
    FilterRegistrationBean<LoginFilter> bean =
            new FilterRegistrationBean<>(new LoginFilter());
    bean.addUrlPatterns("*.d", "/dorado/view-service");
    bean.setOrder(2);
    bean.setName("loginFilter");
    return bean;
}
```

> `order` 值越小优先级越高，保持与 `web.xml` 中 filter-mapping 声明顺序一致。
> 注意: `DelegatingFilterProxy` 需确认是框架的版本还是 Spring 的版本，两者类名相同但功能不同。

### 3.4 为什么不使用 `@ServletComponentScan`？

`@ServletComponentScan` 只能发现带 `@WebServlet`/`@WebFilter`/`@WebListener` 注解的类。
专有框架的 Servlet 通常**无此类注解**，依赖 `web.xml` 的纯声明式注册。因此必须使用
`ServletRegistrationBean` 等编程式注册。

---

## 4. 步骤二：框架 Context 加载

### 4.1 问题

专有框架的 XML 配置通常有**多层 Context 依赖链**。例如 Dorado 7:

```
core/context.xml        ← 定义基础 bean（expressionHandler 等）
  └─ 被所有其他 Context 依赖
common/context.xml      ← 定义 exposedServiceRegister
  └─ 被 view Context 依赖
config/context.xml      ← 定义 dispatchableXmlParser
  └─ 被 data 和 view Context 依赖
data/context.xml        ← 定义数据层 bean
  └─ 依赖 core 和 config
view/context.xml        ← 定义视图层 bean
  └─ 依赖 core、config 和 common
web/context.xml         ← 定义 Web 层 bean
application-context.xml ← 应用配置，依赖所有 Dorado bean
```

### 4.2 解决

在 `@ImportResource` 中按依赖顺序加载:

```java
@ImportResource({
    "classpath:com/bstek/dorado/core/context.xml",       // 1. 基础核心
    "classpath:com/bstek/dorado/common/context.xml",      // 2. 公共服务
    "classpath:com/bstek/dorado/config/context.xml",      // 3. XML 解析器
    "classpath:com/bstek/dorado/data/context.xml",        // 4. 数据层
    "classpath:com/bstek/dorado/view/context.xml",        // 5. 视图层
    "classpath:com/bstek/dorado/web/context.xml",         // 6. Web 层
    "classpath*:WEB-INF/dorado-home/application-context.xml"  // 7. 应用配置
})
```

**顺序不能乱** — 每个 Context 依赖于前一个中定义的 bean。

### 4.3 ROOT Context vs Servlet 子 Context

| 类型 | 加载方式 | Bean 作用域 | 典型内容 |
|------|---------|------------|---------|
| ROOT Context | `@ImportResource` 中显式声明 | 全局共享 | `xxx/context.xml` — 服务 bean |
| Servlet 子 Context | 框架 Servlet.init() 时创建 | Servlet 内部 | `xxx/servlet-context.xml` — HandlerMapping、Resolver |

**关键**:
- `@ImportResource` 应包含 `xxx/context.xml`（ROOT Context）
- `@ImportResource` **不应包含** `xxx/servlet-context.xml`（子 Context 自动加载）
- 子 Context 中的 bean（如 `UriResolverMapping`）仅需在 Servlet 内部存在

---

## 5. 步骤三：框架全局状态初始化

### 5.1 问题

专有框架通常在 `Servlet.init()` 或 `ServletContextListener` 中初始化全局状态。
Spring Boot 下这些监听器不执行，导致框架的静态方法返回 null/NPE。

例如 Dorado 的 `Context.getCurrent()`:
```java
public static Context getCurrent() {
    Context ctx = (threadLocal != null) ? threadLocal.get() : null;
    return (ctx != null) ? ctx : failSafeContext;  // failSafeContext 未设置时为 null
}
```

### 5.2 解决

使用 `ServletContextInitializer` 在嵌入式 Tomcat 创建后初始化:

```java
@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        DoradoContext context = DoradoContext.init(servletContext, false);
        Context.setFailSafeContext(context);
    };
}
```

执行时序:
```
Spring Boot onRefresh()
  └─ createWebServer()
       └─ TomcatStarter.onStartup()
            └─ 执行 ServletContextInitializer ← 在这里设置 failSafeContext
  └─ finishBeanFactoryInitialization()
       └─ 实例化单例 Bean ← 此时 failSafeContext 已就绪
```

### 5.3 与 `DoradoLoader.preload()` 的区别

| 方法 | 作用 | 额外效果 |
|------|------|---------|
| `DoradoContext.init()` | 创建并设置 DoradoContext | 设置 failSafeContext |
| `DoradoLoader.preload()` | 加载所有 package 配置 | 填充 `core.servletContextConfigLocation`（子 Context 配置路径） |

两者的关系: `preload()` 调用了 `DoradoContext.init()` 设置 failSafeContext，再收集 package 配置。

---

## 6. 步骤四：Servlet 子 Context 配置加载

### 6.1 问题

专有框架的 Servlet（继承 `FrameworkServlet`/`DispatcherServlet`）在初始化时会创建自己的子 Context。
该子 Context 需要知道加载哪些 XML 文件。

传统部署中配置通过 `web.xml` 的 `init-param` 传递:
```xml
<servlet>
    <servlet-name>doradoServlet</servlet-name>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:xxx/servlet-context.xml</param-value>
    </init-param>
</servlet>
```

**但 DoradoServlet 覆盖了 `createWebApplicationContext()`，不从 servletContext 读取**:

```java
// DoradoServlet.java — 反编译确认
protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
    // 从 Configure 存储读取，而非 ServletContext 属性！
    String config = Configure.getString("core.servletContextConfigLocation");
    setContextConfigLocation(config);
    return super.createWebApplicationContext(parent);
}
```

### 6.2 解决

操作专有框架的存储层（而非 ServletContext 属性）:

```java
@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        // 1. 先执行 preload() — 收集 package 定义的 servletContextConfigLocations
        DoradoLoader.getInstance().preload(servletContext, true);

        // 2. 从 Configure 存储读取已收集的配置（非 ServletContext 属性！）
        String cscl = Configure.getString("core.servletContextConfigLocation");

        // 3. 追加自定义子 Context 配置
        String custom = "classpath:com/cpic/fms/config/web/dorado-child-context.xml";
        if (cscl != null && !cscl.contains("dorado-child-context")) {
            // 分隔符使用 ';'（与 preload() 内部 StringUtils.join(..., ';') 一致）
            Configure.getStore().set("core.servletContextConfigLocation", cscl + ";" + custom);
        } else if (cscl == null) {
            Configure.getStore().set("core.servletContextConfigLocation", custom);
        }
    };
}
```

### 6.3 自定义子 Context 配置

```xml
<!-- dorado-child-context.xml — 在 Servlet 子 Context 中加载 -->
<beans xmlns="http://www.springframework.org/schema/beans" ...>
    <!-- 注册 BeanPostProcessor，提升 UriResolverMapping 优先级 -->
    <bean class="com.cpic.fms.config.web.DoradoUriResolverOrderPostProcessor" />
</beans>
```

### 6.4 BeanPostProcessor 作用域

通过 `dorado-child-context.xml` 注册的 `BeanPostProcessor` **仅在 Servlet 子 Context 中生效**，
不影响 ROOT Context 中的 Bean。这是 BeanPostProcessor 的作用域特性。

```java
public class DoradoUriResolverOrderPostProcessor implements BeanPostProcessor, Ordered {
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof UriResolverMapping) {
            ((UriResolverMapping) bean).setOrder(Ordered.HIGHEST_PRECEDENCE);
        }
        return bean;
    }
    @Override
    public int getOrder() {
        return 0;
    }
}
```

---

## 7. 通用检查清单

将上述经验抽象为通用方法论，适用于任何专有框架:

### 步骤 A: 分析框架初始化链路

| 检查项 | 方法 |
|--------|------|
| Servlet 初始化 | 搜索 web.xml 中 `<servlet>` 及对应的 class |
| Context 加载链 | 解压框架 JAR，查看 `META-INF/` 或 package 目录下的 context.xml |
| 全局状态设置 | 搜索 `ServletContextListener`、`ServletContextAttribute`、静态字段赋值 |
| init-param 使用 | 搜索 `getInitParameter`、`getServletConfig().getInitParameter()` |
| 配置存储位置 | 搜索 `setAttribute`/`getAttribute`、自定义配置存储类 |

### 步骤 B: 识别断裂点

```
web.xml → ServletRegistrationBean（注册 Servlet）
web.xml init-param → @Bean 方法参数（配置传递）
ServletContextListener → ServletContextInitializer（全局初始化）
ServletContext.setAttribute → Configure.store.set()（存储层适配）
```

### 步骤 C: 逐项修复

```
□ Servlet URL 映射: ServletRegistrationBean
□ Filter 注册+顺序: FilterRegistrationBean + setOrder()
□ Listener 注册: ServletListenerRegistrationBean
□ ROOT Context 加载: @ImportResource（按依赖序）
□ 子 Context 配置: 框架存储层追加
□ 全局状态初始化: ServletContextInitializer
□ BeanPostProcessor 作用域: 子 Context XML 注册
```

### 步骤 D: 验证

```
□ mvn compile 编译通过
□ 启动无 BeanDefinitionOverrideException
□ 启动无 NoSuchBeanDefinitionException
□ 框架的 URL 模式请求正常（不返回 404）
□ 框架页面渲染正常
□ 框架的 Filter/Interceptor 链正常执行
□ WAR 部署方式不冲突
```
