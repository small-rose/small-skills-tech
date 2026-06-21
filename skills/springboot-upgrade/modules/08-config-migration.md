# 配置体系升级迁移指南

> **适用场景**: 传统 Spring MVC 升级到 Spring Boot 时，配置体系的改造。
> **核心问题**: Maven Profile → Spring Boot Profile 归并、PropertyPlaceholder 升级、密码解密链路重建

---

## 1. 配置体系演进路线

| 阶段 | 架构 | 缺点 |
|------|------|------|
| 传统 WAR | 多个 `.properties` 文件 + `PropertyPlaceholderConfigurer` | 散乱、无 Profile 管理 |
| 传统 + Maven Profile | Maven Profile 选择配置目录 + 资源复制 | 构建时绑定，运维不友好 |
| **Spring Boot** | `application-{profile}.properties` + Environment | 运行时切换，标准化 |

### 1.1 升级模式对照

| 旧模式 | 新模式 | 说明 |
|--------|--------|------|
| `PropertyPlaceholderConfigurer` + `locations` | `PropertySourcesPlaceholderConfigurer` + Environment | 从文件加载改为 Environment 绑定 |
| Maven Profile (`<profiles>`) | Spring Profile (`spring.profiles.active`) | 从构建时切换改为运行时切换 |
| `ResourceBundle.getBundle("xxx")` | `@Value("${xxx}")` + `@Component` | 从静态查找改为 DI 注入 |
| `WebApplicationContextUtils.getWebApplicationContext()` | `ApplicationContextAware` / `@Inject` | 统一依赖注入方式 |

---

## 2. Maven Profile → Spring Boot Profile 归并

### 2.1 旧架构（Maven Profile）

```xml
<!-- pom.xml -->
<profiles>
    <profile>
        <id>FMS_PRD_DEV</id>
        <activation><activeByDefault>true</activeByDefault></activation>
        <build>
            <resources>
                <resource>
                    <directory>ServerConfiguration/profiles/FMS_PRD_DEV</directory>
                    <includes>
                        <include>*.properties</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </profile>
    <profile>
        <id>FMS_PRD_PRO</id>
        <!-- 类似配置，指向不同目录 -->
    </profile>
</profiles>
```

**缺点**:
- Profile 切换需重新 Maven 构建
- 多个 `.properties` 文件散落各目录（7 个文件 × 3 环境 = 21 个源文件）
- 公共配置在三份中冗余（如 ESAPI.properties 三份完全一样）

### 2.2 新架构（Spring Boot Profile）

```
src/main/resources/
├── application.properties                    # 公共配置（所有环境共享）
├── application-local.properties              # 本地环境差异配置
├── application-dev.properties                # 开发环境差异配置
└── application-prod.properties               # 生产环境差异配置
```

激活方式: `spring.profiles.active=local`（默认）或启动参数 `-Dspring.profiles.active=prod`。

### 2.3 归并策略

| 旧文件 | 目标位置 | 处理方式 |
|--------|---------|----------|
| `jdbc.properties` | `application-{profile}.properties` | 各环境不同，归入差异化文件 |
| `redis.properties` | `application-{profile}.properties` | 各环境不同，归入差异化文件 |
| `application-context.properties` | `application-{profile}.properties` | `system=LOCAL` 等单行属性 |
| 公共 Solr/Pinyin URL | `application.properties` | 所有环境共享 |
| Hibernate 配置 | `application.properties` | 所有环境共享（原在 XML hibernateProperties 中） |
| `configure.properties` | 保留原位 | 通过 `spring.config.import` 加载 |
| `ESAPI.properties` | **不再使用** | Spring Boot 不需要 |
| `validation.properties` | **不再使用** | 配置已移入 application.properties |

### 2.4 外部配置文件加载

Dorado 的 `configure.properties` 保留在原目录（`WEB-INF/dorado-home/`），通过 Spring Boot 的 `spring.config.import` 加载：

```properties
# application.properties
spring.config.import=classpath:WEB-INF/dorado-home/configure.properties
```

---

## 3. PropertyPlaceholder 升级

### 3.1 三种 PropertyPlaceholder 类型

| 类型 | 说明 | Spring Boot 支持 |
|------|------|-----------------|
| `PropertyPlaceholderConfigurer` | Spring 3.x 方式，已废弃 | 不推荐 |
| `PropertySourcesPlaceholderConfigurer` | Spring 4.x+ 方式，基于 Environment | ✅ 推荐 |
| `Environment` + `@Value` | Spring Boot 原生 | ✅ 最推荐 |

### 3.2 升级路径

```
PropertyPlaceholderConfigurer (废弃)
        ↓
PropertySourcesPlaceholderConfigurer (兼容)
        ↓
Environment + @Value + @ConfigurationProperties (推荐)
```

### 3.3 代码示例

**旧版**（`PropertyPlaceholderConfigurer` 子类，手动加载文件）:

```java
public class LegacyConfigurer extends PropertyPlaceholderConfigurer {
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) {
        Properties props = new Properties();
        // 手动加载 7 个 properties 文件
        props.load(new FileReader("jdbc.properties"));
        props.load(new FileReader("redis.properties"));
        // ... 解密密码 ...
        processProperties(beanFactory, props);
    }
}
```

**新版**（`PropertySourcesPlaceholderConfigurer` + PropertySource 装饰器）:

```java
public class DecryptPropertySourcesConfigurer extends PropertySourcesPlaceholderConfigurer {
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) {
        // 1. 复制 Environment 所有 PropertySource
        MutablePropertySources merged = new MutablePropertySources();
        for (PropertySource<?> ps : this.getEnvironment().getPropertySources()) {
            merged.addLast(ps);
        }
        // 2. 前置插入解密装饰器
        merged.addFirst(new DecryptedPropertySource(merged));
        // 3. 替换默认的 PropertySources
        this.setPropertySources(merged);
        // 4. 调用父类处理
        super.postProcessBeanFactory(beanFactory);
    }
}

class DecryptedPropertySource extends PropertySource<String> {
    @Override
    public String getProperty(String key) {
        String rawValue = ...; // 从原始 PropertySource 获取
        if (key != null && key.endsWith("jdbc.password")) {
            return DesEncrypt.getDesString(rawValue); // 3DES 解密
        }
        return rawValue;
    }
}
```

### 3.4 自定义 PropertyPlaceholderConfigurer 注册为 Bean

```java
@Bean
public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
    DecryptPropertySourcesConfigurer configurer = new DecryptPropertySourcesConfigurer();
    configurer.setIgnoreUnresolvablePlaceholders(true); // 必设 — 与其他 Configurer 共存
    return configurer;
}
```

> `static` 必须保留：`PropertySourcesPlaceholderConfigurer` 实现 `BeanFactoryPostProcessor`，在容器早期阶段创建。

---

## 4. 密码解密链路重建

### 4.1 问题场景

传统架构中密码解密通过自定义 `PropertyPlaceholderConfigurer` 在 `postProcessBeanFactory()` 中完成：
1. 从文件加载所有属性到 `Properties` 对象
2. 遍历 key，找到 `jdbc.password` 结尾的属性 → 3DES 解密
3. 放入 Properties 对象供 `${...}` 解析

升级到 Spring Boot 后：
- 配置文件改由 Environment 管理（不是手动加载的 Properties 对象）
- 解密逻辑需要从 "修改 Properties 对象" 改为 "拦截 PropertySource.getProperty()"

### 4.2 PropertySource 装饰器模式

```
Environment
  └─ PropertySource 链
       ├─ application.properties           ← 公共配置
       ├─ application-{profile}.properties ← 环境差异配置（含 JDBC 密文密码）
       ├─ spring.config.import             ← 外部配置文件
       └─ ...其他 PropertySource

DecryptedPropertySource（前置插入）
  └─ getProperty("jdbc.password"):
       ├─ rawValue = 原始 PropertySource.getProperty("jdbc.password")
       ├─ key.endsWith("jdbc.password") → DesEncrypt.getDesString(rawValue)
       └─ 返回解密后的明文
```

### 4.3 多 PropertySourcesPlaceholderConfigurer 共存时序

```invokeBeanFactoryPostProcessors:
  1. PriorityOrdered BFPP: DecryptPropertySourcesConfigurer
     └─ ignoreUnresolvablePlaceholders=true → 跳过无法解析的占位符
     └─ 例如 Dorado 的 ${core.globalResource.cache.timeToLive} 等
  2. 普通 BFPP: Dorado ConfigureProperiesConfigurer
     └─ 从 Dorado ConfigureStore 加载属性 → 解析 core.* 等
     └─ 该 Configurer 构造器默认设了 ignoreUnresolvablePlaceholders=true
```

**关键**: 自定义 Configurer 必须设 `ignoreUnresolvablePlaceholders=true`，否则遇到其他 Configurer 负责的占位符会报错。

---

## 5. SystemEnv 重构

### 5.1 问题

传统项目使用 `ResourceBundle.getBundle("application-context")` 读取 `system` 环境标识：

```java
// 旧方式 — 静态调用，无 DI
String system = ResourceBundle.getBundle("application-context").getString("system");
```

Profile 归并后 `application-context.properties` 文件被删除 → `MissingResourceException`。

### 5.2 修复方案

```java
@Component
public class SystemEnvProp {
    @Value("${system}")
    private String system;

    public String getSystem() {
        return system;
    }
}
```

时序保证:
```
prepareEnvironment() → Environment 就绪 system=LOCAL
  ↓ (bean 创建阶段)
SystemEnvProp → @Value("${system}") → system="LOCAL"
  ↓ (依赖注入)
其他 Bean → @Inject SystemEnvProp → getSystem() = "LOCAL"
```

### 5.3 改造清单

| 旧方式 | 新方式 | 改造点 |
|--------|--------|--------|
| `ResourceBundle.getBundle("application-context")` | `@Inject SystemEnvProp` | 所有引用处改为 DI 注入 |
| `SystemEnv` 静态类 | `SystemEnvProp` `@Component` | 类改造 |
| 非 Spring 管理类（HttpServlet） | `SpringContextHolder.getBean(SystemEnvProp.class)` | 兜底获取 |

---

## 6. 常见陷阱

### 6.1 `<resources>` 配置过窄

```xml
<!-- ❌ 只包含特定类型文件 -->
<resource>
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*.bar</include>
        <include>**/*.drl</include>
    </includes>
</resource>

<!-- ✅ 包含所有资源文件 -->
<resource>
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*</include>
    </includes>
</resource>
```

后果: `application.properties`、`logback.xml` 等未编译到 `target/classes/`。

### 6.2 `spring-boot-starter-web` scope 问题

```xml
<!-- ❌ 设 provided 可能导致嵌入式 Tomcat 不启动 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <scope>provided</scope>
</dependency>

<!-- ✅ 保留 compile scope 以确保嵌入式 Tomcat 正常 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

排查: `mvn dependency:tree | grep tomcat` 检查 Tomcat scope。

### 6.3 双路径 XML 加载策略

当需要同时支持本地开发（`file:` 路径）和生产部署（`classpath:` 路径）时:

```java
@ImportResource({
    "classpath*:WEB-INF/dorado-home/application-context.xml",
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
```

Spring 按顺序加载，classpath 优先。推荐仅使用 `classpath:` 模式配合 Maven 资源复制。
