# 第九步：常见错误案例库

#### 9.1 启动失败常见问题

```yaml
startup_failures:
  
  - error: "ClassNotFoundException: javax.servlet.http.HttpServletRequest"
    cause: "Spring Boot 3.x使用jakarta包"
    solution: "执行javax到jakarta迁移，或保持Boot 2.x"
    
  - error: "No qualifying bean of type 'PlatformTransactionManager'"
    cause: "事务管理器配置缺失"
    solution: "添加@EnableTransactionManagement或检查数据源配置"
    
  - error: "Application启动时没有扫描到Bean"
    cause: "包扫描路径不正确"
    solution: "将启动类放在根包下，或使用@ComponentScan指定"
    
  - error: "Port already in use"
    cause: "端口冲突或未正确配置"
    solution: "配置server.port或关闭占用端口的进程"
    
  - error: "Failed to configure a DataSource: 'url' attribute is not specified"
    cause: "数据源配置缺失"
    solution: "配置spring.datasource.url或排除自动配置"
    
  - error: "Circular reference detected"
    cause: "Spring Boot 2.6+默认禁止循环依赖"
    solution: "配置spring.main.allow-circular-references=true或重构代码"
    
  - error: "Whitelabel Error Page"
    cause: "没有配置错误页面或视图解析"
    solution: "配置error视图或使用@RestController处理异常"
```

#### 9.2 运行时常见问题

```yaml
runtime_issues:
  
  - issue: "配置属性不生效"
    cause: "属性名在新版本中变更"
    solution: "查阅官方文档的属性迁移指南"
    
  - issue: "序列化异常"
    cause: "Jackson版本变更导致"
    solution: "检查Jackson配置和自定义序列化器"
    
  - issue: "事务不生效"
    cause: "代理模式或包扫描问题"
    solution: "确保@Transactional在public方法上"
    
  - issue: "Security配置失效"
    cause: "Spring Security 6.x配置方式变更"
    solution: "使用SecurityFilterChain替代WebSecurityConfigurerAdapter"
```

#### 9.3 升级调试技巧速查表

**问题 4: Bean 冲突**

```
错误: BeanCreationException: Invalid bean definition with name 'xxx'

症状:
- 启动时报 "already defined" 或 "Invalid bean definition"
- 多个同类型Bean导致注入歧义

调试步骤:
1. 启动时添加 --debug 查看自动配置报告
2. 搜索日志中的 "bean definition" 关键字
3. 使用 grep -r "@Component\|@Service\|@Repository" src/ 排查重复定义

解决方案:
1. 检查 Bean 名称冲突 - 使用 @Bean(name="xxx") 指定唯一名称
2. 使用 @Primary 注解 - 标记主要Bean
3. 排除自动配置 - @SpringBootApplication(exclude={XxxAutoConfiguration.class})
4. 使用 @ConditionalOnMissingBean - 自动跳过已存在的Bean
```

**问题 5: XML 配置加载失败**

```
错误: FileNotFoundException: classpath:xxx.xml 或 IOException: Invalid input

症状:
- 启动时报找不到XML配置文件
- XML解析错误

调试步骤:
1. 检查文件路径 - ls -la src/main/resources/
2. 确认类加载路径 - mvn dependency:build-classpath
3. 查看Spring日志中的XML加载记录

解决方案:
1. 检查 XML 文件路径 - 确保在classpath根目录下
2. 确保 XML 文件在 classpath 中 - 使用@ImportResource("classpath:xxx.xml")
3. 使用 @ImportResource 指定路径 - @ImportResource({"classpath:spring/*.xml"})
4. 扫描指定包 - <context:component-scan base-package="com.xxx"/>
```

**问题 6: 版本冲突**

```
错误: NoSuchMethodError, ClassNotFoundException, NoClassDefFoundError

症状:
- 运行时找不到类或方法
- 启动时依赖注入失败

调试步骤:
1. 检查 Maven 依赖树 - mvn dependency:tree -Dverbose
2. 查找冲突依赖 - mvn dependency:tree | grep "XXX"
3. 分析依赖仲裁 - mvn dependency:tree -Dverbose | grep "omitted"

解决方案:
1. 检查 Maven 依赖树 - mvn dependency:tree
2. 排除冲突依赖 - <exclusions><exclusion>...</exclusion></exclusions>
3. 统一版本管理 - 使用dependencyManagement锁定版本
4. 使用BOM管理 - <dependencyManagement><dependencies><dependency>...
```

**问题 7: 循环依赖**

```
错误: Circular reference detected

症状:
- Spring Boot 2.6+默认禁止循环依赖
- 启动时创建Bean失败

调试步骤:
1. 检查依赖关系 - 使用IDEA的Analyze → Inspect Code
2. 搜索循环引用 - grep -r "@Autowired" src/ | sort
3. 查看启动日志中的dependency chain

解决方案:
1. 重构代码 - 消除循环依赖（推荐）
2. 临时允许循环依赖 - spring.main.allow-circular-references=true
3. 使用@Lazy延迟加载 - @Lazy注解打破循环
4. 提取公共Bean - 抽取公共依赖为独立Bean
```

**问题 8: 配置属性不生效**

```
错误: 属性配置后程序未按预期运行

症状:
- application.yml/properties修改后无效
- 新版本属性名变更

调试步骤:
1. 查看自动配置报告 - 启动时加 --debug 或 logging.level.org.springframework.boot.autoconfigure=DEBUG
2. 使用Actuator端点 - 访问 /actuator/configprops
3. 检查属性名变更 - 查阅官方迁移文档

解决方案:
1. 检查属性名在新版本中变更 - 使用@Deprecated配置别名
2. 使用@ConfigurationProperties绑定 - @ConfigurationProperties(prefix="xxx")
3. 确保属性前缀正确 - spring.xxx.yyy 格式
4. 检查环境变量覆盖 - 环境变量优先级高于配置文件
```

**问题 9: 数据库连接失败**

```
错误: Unable to acquire JDBC Connection, Communications link failure

症状:
- 数据源配置正确但连接失败
- HikariCP连接池错误

调试步骤:
1. 测试数据库连接 - mysql -u root -p
2. 检查驱动版本 - mvn dependency:tree | grep mysql
3. 查看连接池日志 - logging.level.com.zaxxer.hikari=DEBUG

解决方案:
1. 检查驱动类名 - Boot 3.x使用com.mysql.cj.jdbc.Driver
2. 配置连接池参数 - spring.datasource.hikari.maximum-pool-size=10
3. 添加时区参数 - ?serverTimezone=Asia/Shanghai
4. 配置SSL - ?useSSL=false
```

**问题 10: Jackson序列化异常**

```
错误: JsonMappingException, InvalidDefinitionException

症状:
- JSON序列化/反序列化失败
- 日期格式问题

调试步骤:
1. 检查Jackson版本 - mvn dependency:tree | grep jackson
2. 查看序列化配置 - 搜索 @JsonFormat, @JsonProperty
3. 测试JSON转换 - 编写单元测试验证

解决方案:
1. 配置日期格式 - spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
2. 处理空值 - spring.jackson.default-property-inclusion=non_null
3. 忽略未知属性 - @JsonIgnoreProperties(ignoreUnknown=true)
4. 自定义序列化器 - @JsonSerialize(using=xxx.class)
```

**问题 11: Spring Security配置问题**

```
错误: 403 Forbidden, Access Denied, Unable to invoke SecurityFilterChain

症状:
- 认证/授权不生效
- 安全配置冲突

调试步骤:
1. 启用Security调试 - logging.level.org.springframework.security=DEBUG
2. 检查Filter顺序 - @Order注解
3. 查看自动配置报告 - SecurityFilterChain自动配置

解决方案:
1. 使用SecurityFilterChain替代WebSecurityConfigurerAdapter
2. 配置请求规则 - http.authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
3. 禁用CSRF - http.csrf(csrf -> csrf.disable())
4. 配置CORS - http.cors(Customizer.withDefaults())
```

**问题 12: 测试无法启动**

```
错误: Failed to load ApplicationContext, Could not find ApplicationContext

症状:
- 单元测试启动失败
- 测试环境配置错误

调试步骤:
1. 检查测试配置 - @SpringBootTest注解
2. 查看测试日志 - 搜索 "Test context" 关键字
3. 隔离测试配置 - 使用@ActiveProfiles("test")

解决方案:
1. 配置测试属性 - @TestPropertySource(locations="classpath:test.yml")
2. 模拟Bean - @MockBean替代真实依赖
3. 排除自动配置 - @SpringBootTest(exclude={...})
4. 使用WebMvcTest - @WebMvcTest(Controller.class)
```

**问题 13: Maven/Gradle依赖下载失败**

```
错误: Could not resolve dependencies, Failed to execute goal

症状:
- 构建时依赖下载失败
- 仓库连接超时

调试步骤:
1. 检查网络连接 - curl https://repo.maven.apache.org
2. 查看本地仓库 - ls ~/.m2/repository
3. 分析依赖树 - mvn dependency:analyze

解决方案:
1. 配置镜像源 - settings.xml配置阿里云镜像
2. 清理本地缓存 - mvn dependency:purge-local-repository
3. 强制更新 - mvn -U clean install
4. 检查版本可用性 - 确认依赖版本在仓库中存在
```

---

#### 9.4 实战升级错误案例库（FMS项目经验）

本节的案例来自传统 Spring MVC + Dorado 7 专有框架升级到 Spring Boot 2.7.18 的真实项目，涵盖了从 POM 改造到专有框架兼容的全过程。

**案例 1: Woodstox 多版本冲突 — `NoSuchMethodError: writeLong()`**

```
错误: java.lang.NoSuchMethodError: org.codehaus.stax2.XMLStreamWriter2.writeLong(J)V
  at com.fasterxml.jackson.dataformat.xml.ser.ToXmlGenerator.writeNumber(...)

根因:
classpath 上存在 3 个 Woodstox 版本:
  ✅ woodstox-core:6.4.0    — jackson-dataformat-xml 传递 (有 writeLong)
  ❌ woodstox-core-asl:4.4.1 — cxf-core:3.1.4 传递 (无 writeLong)
  ❌ wstx-asl:3.2.7          — solr-solrj:4.5.0 传递 (无 writeLong)
旧版 JAR 被类加载器优先加载 → NoSuchMethodError

解决:
<!-- cxf-core 排除旧版 -->
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-core</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.codehaus.woodstox</groupId>
            <artifactId>woodstox-core-asl</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<!-- solr-solrj 排除旧版 -->
<dependency>
    <groupId>org.apache.solr</groupId>
    <artifactId>solr-solrj</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.codehaus.woodstox</groupId>
            <artifactId>wstx-asl</artifactId>
        </exclusion>
    </exclusions>
</dependency>
保留 jackson-dataformat-xml（项目需要），让 woodstox-core:6.4.0 成为唯一实现。
```

**案例 2: EhCache 类路径冲突 — 新旧 ehcache-core 并存**

```
错误: 启动时报类加载冲突 — Ehcache 相关 NoSuchMethodError

根因:
  ❌ ehcache-core:2.6.9              — 项目显式声明（旧）
  ✅ ehcache:2.10.9.2                 — hibernate-ehcache 传递（新）
两者 `net.sf.ehcache` 包名相同但 API 不兼容，类加载器随机加载其中一个

解决:
移除项目显式声明的 ehcache-core:2.6.9，仅保留 ehcache:2.10.9.2（通过 hibernate-ehcache 传递）
```

**案例 3: Spring Data Redis 1.x→2.x — RedisCacheConfiguration 不可变类**

```
错误: Invalid property 'entryTtl' of bean class [...RedisCacheConfiguration]:
       Bean property 'entryTtl' is not writable or has an invalid setter method.

根因:
RedisCacheConfiguration 是不可变类（所有字段 private final，构造器 private）。
配置必须通过 builder 模式方法（如 .entryTtl(Duration)）返回新实例，但 Spring XML
的 <property> 标签会调用 setter → 不存在 → 报错。

解决:
创建 FactoryBean 包装类 RedisCacheConfigurationFactory:
public class RedisCacheConfigurationFactory implements FactoryBean<RedisCacheConfiguration> {
    private Duration entryTtl = Duration.ofHours(36);
    private boolean disableCachingNullValues = true;
    public void setEntryTtl(Duration v) { this.entryTtl = v; }
    public void setDisableCachingNullValues(boolean v) { this.disableCachingNullValues = v; }
    @Override
    public RedisCacheConfiguration getObject() {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(entryTtl)
            .serializeKeysWith(...)
            .serializeValuesWith(...);
        if (disableCachingNullValues) config = config.disableCachingNullValues();
        return config;
    }
}
XML 中 bean class 改为 RedisCacheConfigurationFactory，保留 <property> 注入。
```

**案例 4: Spring Data Redis 1.x→2.x — MyRedisCacheManager API 变化**

```
错误: 继承 RedisCacheManager 的子类方法签名不匹配

根因: RedisCacheManager 1.x → 2.x:
  - 方法名: createCache() → createRedisCache()
  - 可见性: public → protected
  - 参数: (String) → (String, @Nullable RedisCacheConfiguration)
  - 构造器: (RedisTemplate) → (RedisCacheWriter, RedisCacheConfiguration)

解决:
@Override
protected RedisCache createRedisCache(String name, @Nullable RedisCacheConfiguration cacheConfig) {
    RedisCacheConfiguration config = cacheConfig != null ? cacheConfig : this.defaultCacheConfiguration;
    return new MyRedisCache(name, this.cacheWriter, config);
}
```

**案例 5: JedisConnectionFactory — 构造器签名变更**

```
错误: JedisConnectionFactory.setHostName()/setPort()/setPassword() 方法找不到

根因: Spring Data Redis 2.x 中 JedisConnectionFactory 不再提供 setHostName/setPort
等 setter，改为通过 RedisStandaloneConfiguration 构造器传入。

解决:
<!-- 新增 RedisStandaloneConfiguration -->
<bean id="redisStandaloneConfiguration"
      class="org.springframework.data.redis.connection.RedisStandaloneConfiguration">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
</bean>
<!-- JedisConnectionFactory 改为构造器注入 -->
<bean id="jedisConnectionFactory"
      class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <constructor-arg ref="redisStandaloneConfiguration"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

**案例 6: MyCompositeCacheManager.getCacheNames() — 不可修改集合上调用 retainAll**

```
错误: java.lang.UnsupportedOperationException
  at MyCompositeCacheManager.getCacheNames()

根因:
Spring 5.3.x 的 CacheManager.getCacheNames() 返回 Collections.unmodifiableSet()。
源码中对该集合直接调用 retainAll() → 不可修改集合抛异常。

解决:
// ❌ 错误写法
Collection<String> names1 = levelOneCacheManager.getCacheNames();
names1.retainAll(names2);  // ← names1 不可修改

// ✅ 正确写法 — 复制到可变 Set 后再操作
Set<String> names = new LinkedHashSet<>(levelOneCacheManager.getCacheNames());
names.retainAll(levelTwoCacheManager.getCacheNames());
return Collections.unmodifiableSet(names);
```

**案例 7: 循环依赖 — fndsoft 工作流引擎**

```
错误: The dependencies of some of the beans in the application context form a cycle
  activitiExtendService → WFTaskService → activitiTaskServiceAdapter → activitiExtendService

根因:
fndsoft 工作流引擎的历史设计：activitiExtendService 和 WFTaskService 互相依赖。
Spring Boot 2.6+ 默认禁止循环引用（2.5 以下允许）。

解决:
# application.properties
spring.main.allow-circular-references=true

评估:
  - 方案A（推荐）: 配置允许循环引用，不改动引擎代码（风险低，2行配置）
  - 方案B: 用 @Lazy 注解打破循环，需改动 fndsoft 引擎代码（风险高）
```

**案例 8: Maven 资源配置过窄 — application.properties 未编译**

```
错误: FileNotFoundException: classpath:application.properties

根因:
pom.xml 中 <resources> 块只包含 *.bar / *.drl / *.bpmn，src/main/resources
下的 application.properties / logback.xml 等未被复制到 target/classes/。

解决:
<resource>
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*</include>  <!-- 改为包含所有文件 -->
    </includes>
</resource>
```

**案例 9: jdbc.properties 未加载 — 占位符无法解析**

```
错误: Could not resolve placeholder 'jdbc.driverClass' in value "${jdbc.driverClass}"

根因:
DecryptPropertyPlaceholderConfigurer 的 locations 列表少了 jdbc.properties。
jdbc.properties 虽已被 Maven Profiles 复制到 target/classes/，但未被任何
PropertyPlaceholderConfigurer 加载。

解决:
在 application-context.xml 的 <bean class="DecryptPropertyPlaceholderConfigurer">
的 locations 列表中新增 <value>classpath:jdbc.properties</value>。
```

**案例 10: components.properties 未加载 + redis 键名不匹配**

```
错误: Could not resolve placeholder 'richdata.url' in value "${richdata.url}"
```

根因 + 解决双重问题:
1. components.properties 未被 DecryptPropertyPlaceholderConfigurer 加载 → locations 列表中新增
2. context-cache.spring.xml 中 `${redis.password}` 在 redis.properties 中实际键名为
   `${redis.pass}` → 修正引用键名
```

**案例 11: Dorado 核心 Context 缺失 — Bean 未定义**

```
错误: No bean named 'dorado.globalResourceSearchPathRegister' available

根因:
Dorado 框架的 core/context.xml 从未被加载（传统部署由 DoradoServlet 初始化时加载，
Spring Boot 下需要显式 @ImportResource）。该文件定义了 dorado.globalResourceSearchPathRegister
等核心 bean。

解决:
在 @ImportResource 中补充 Dorado Context 加载链（按依赖顺序）:
@ImportResource({
    "classpath:com/bstek/dorado/core/context.xml",       // 1. 基础核心
    "classpath:com/bstek/dorado/common/context.xml",      // 2. 公共服务
    "classpath:com/bstek/dorado/config/context.xml",      // 3. XML 解析器
    "classpath:com/bstek/dorado/data/context.xml",        // 4. 数据层
    "classpath:com/bstek/dorado/view/context.xml",        // 5. 视图层
    "classpath:com/bstek/dorado/web/context.xml",         // 6. Web 层
    "classpath*:WEB-INF/dorado-home/application-context.xml"  // 7. 应用配置
})
顺序重要: core → common → config → data → view → web → application-context
```

**案例 12: Dorado FailSafeContext 未初始化 — DataOutputter 静态初始化 NPE**

```
错误: java.lang.ExceptionInInitializerError → java.lang.NullPointerException
  at DataOutputter.<clinit>(DataOutputter.java:54)
  at ResourceManagerUtils.get(ResourceManagerUtils.java:29)

根因:
DataOutputter 的静态初始化块 → ResourceManagerUtils.get() → Context.getCurrent()。
传统部署下 DoradoLoader.preload() 会设置 failSafeContext 静态字段，但 Spring Boot
下 preload() 未被调用 → failSafeContext=null → Context.getCurrent() 返回 null → NPE。
该 NPE 未被 ApplicationContextNotInitException 捕获（因为 failSafeContext 为 null 跳过了
getServiceBean 的 try-catch）。

解决:
@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        DoradoContext context = DoradoContext.init(servletContext, false);
        Context.setFailSafeContext(context);
    };
}
执行时序: onRefresh() → ServletContextInitializer → 设置 failSafeContext →
finishBeanFactoryInitialization() → DataOutputter 初始化 → Context.getCurrent() 能取到
```

**案例 13: DoradoServlet 子 Context 配置读取位置错误**

```
错误: DoradoServlet 注册成功但 *.d 请求返回 404

根因（反编译确认）:
DoradoServlet.createWebApplicationContext() 从 Configure 存储读取配置:
    String config = Configure.getString("core.servletContextConfigLocation");  // ← 从 Configure 存储
而不是从 ServletContext 属性:
    servletContext.getInitParameter("core.servletContextConfigLocation")      // ← 无效
    servletContext.getAttribute("core.servletContextConfigLocation")          // ← 无效

解决:
// ❌ 错误 — 写入 ServletContext
servletContext.setAttribute("core.servletContextConfigLocation", cscl + "," + custom);

// ✅ 正确 — 写入 Configure 存储（且分隔符用 ';' 而非 ','）
Configure.getStore().set("core.servletContextConfigLocation", cscl + ";" + custom);
DoradoLoader.preload() 内部使用 StringUtils.join(list, ';')，追加时必须保持一致。
```

**案例 14: Dorado Context 兜底机制缺失 — `@ImportResource` 不包含 servlet-context.xml**

```
错误背景:
web/context.xml 在 @ImportResource 中，但 web/servlet-context.xml 不在其中。
后者仅通过 dorado-core 的 package 机制加载到 DoradoServlet 的子 Context 中。
这是正确行为 — UriResolverMapping 只需在子 Context 中存在。

关键发现:
- @ImportResource 包含 web/context.xml（ROOT Context）但不应包含 web/servlet-context.xml
- servlet-context.xml 由 DoradoLoader.preload() 收集的 package servletContextConfigLocations 加载
- 两者的区别：xxx/context.xml 在 ROOT Context，xxx/servlet-context.xml 在 Servlet 子 Context
```

**案例 15: BeanPostProcessor 作用域 — 仅在子 Context 生效**

```
问题: DoradoUriResolverOrderPostProcessor 需要在 DoradoServlet 的子 Context 中
提升 UriResolverMapping 的 order 到 HIGHEST_PRECEDENCE，但不能影响 ROOT Context。

解决:
将 DoradoUriResolverOrderPostProcessor 注册在 dorado-child-context.xml 中:
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans" ...>
    <bean class="com.cpic.fms.config.web.DoradoUriResolverOrderPostProcessor" />
</beans>

该 XML 仅在 DoradoServlet 的子 Context 中加载（通过 Configure 存储的
core.servletContextConfigLocation 追加），BeanPostProcessor 仅对子 Context 内的 Bean 生效。
```

**案例 16: 静态资源路径不匹配 — HTML 中 `../resources/static/` 404**

```
错误: 登录页 HTML 中的 JS/CSS 引用路径返回 404
<script src="../resources/static/jquery-3.7.1.js"></script>

根因:
HTML 中的 ../resources/static/ 路径从 /fms/logincommon.html 解析为
/resources/static/XXX.js，但 Spring Boot 默认的 classpath:/static/ 映射不包含
/resources/static/ 这一层前缀。

解决:
添加自定义资源映射（不改动 400 行 HTML 代码）:
@Bean
public WebMvcConfigurer staticResourceConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
            registry.addResourceHandler("/resources/static/**")
                    .addResourceLocations("classpath:/static/");
        }
    };
}
```

**案例 17: 密码解密链路 — PropertySourcesPlaceholderConfigurer 未注册为 Bean**

```
错误: DataSource 使用了加密密文作为密码连接数据库失败
（如 "Xu8707OISto/ohNN2m1yhQ=="）

根因:
DecryptPropertyPlaceholderConfigurer 虽有解密逻辑（3DES），但从未注册为 Spring Bean。
传统部署中它在 application-context.xml 作为 <bean> 定义，Profile 归并后该 XML <bean>
被注释，但没有对应的 @Bean 方法替代。

解决:
@Bean
public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
    DecryptPropertyPlaceholderConfigurer configurer = new DecryptPropertyPlaceholderConfigurer();
    configurer.setIgnoreUnresolvablePlaceholders(true);  // 必设 — 与 Dorado ConfigureProperiesConfigurer 共存
    return configurer;
}
static 必须保留，因为 BeanFactoryPostProcessor 在容器早期阶段创建。
```

**案例 18: 解密链路与 Dorado 占位符冲突**

```
错误（追加解密 Bean 后）:
Could not resolve placeholder 'core.globalResource.cache.timeToLive'

根因:
DecryptPropertyPlaceholderConfigurer（extends PropertySourcesPlaceholderConfigurer）
默认 ignoreUnresolvablePlaceholders=false，遇到 Dorado 的 Configure 占位符时抛异常。

执行时序:
  invokeBeanFactoryPostProcessors:
    1. PriorityOrdered BFPP — DecryptPropertyPlaceholderConfigurer
       └─ ignoreUnresolvablePlaceholders=true → 跳过 Dorado 占位符
    2. 普通 BFPP — Dorado ConfigureProperiesConfigurer
       └─ 从 Dorado ConfigureStore 加载属性 → 解析 core.* 等占位符

解决:
configurer.setIgnoreUnresolvablePlaceholders(true);
两者各司其职，互不干扰。
```

---

#### 9.5 外部文章补充案例库

以下案例来自社区 Spring Boot 1.5→2.5 升级实践，补充常见于 Boot 版本断代升级的问题。

**案例 19: Spring Session 表结构不兼容 — 1.x→2.x 模式变更**

```
错误: ORA-00942: table or view does not exist
      或: INSERT INTO SPRING_SESSION (...) VALUES (...)

根因: Spring Session 1.x 和 2.x 的表结构不同:

1.x: SPRING_SESSION 主键 = SESSION_ID (VARCHAR2)
2.x: SPRING_SESSION 主键 = PRIMARY_ID (CHAR(36)), SESSION_ID 改为唯一索引

建表脚本必须更新，旧表不会自动迁移。

1.x 表结构:
CREATE TABLE SPRING_SESSION (
    SESSION_ID VARCHAR2(36) NOT NULL,
    CREATION_TIME NUMBER(19) NOT NULL,
    LAST_ACCESS_TIME NUMBER(19) NOT NULL,
    MAX_INACTIVE_INTERVAL NUMBER(10) NOT NULL,
    PRINCIPAL_NAME VARCHAR2(100),
    CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (SESSION_ID)
);

2.x 表结构:
CREATE TABLE SPRING_SESSION (
    PRIMARY_ID CHAR(36) NOT NULL,
    SESSION_ID CHAR(36) NOT NULL,
    CREATION_TIME NUMBER(19,0) NOT NULL,
    LAST_ACCESS_TIME NUMBER(19,0) NOT NULL,
    MAX_INACTIVE_INTERVAL NUMBER(10,0) NOT NULL,
    EXPIRY_TIME NUMBER(19,0) NOT NULL,
    PRINCIPAL_NAME VARCHAR2(100),
    CONSTRAINT SPRING_SESSION_PK PRIMARY KEY (PRIMARY_ID)
);
CREATE UNIQUE INDEX SPRING_SESSION_IX1 ON SPRING_SESSION(SESSION_ID);

解决:
  - 开发环境: 删旧表重建（清空所有登录会话）
  - 生产环境: 编写迁移脚本，将旧表数据转换到新表结构
  - 依赖变化: compile('org.springframework.session:spring-session')
    → compile('org.springframework.session:spring-session-core')
      + compile('org.springframework.session:spring-session-jdbc')
```

**案例 20: spring-boot-starter-validation 显式添加**

```
错误: javax.validation.ValidationException: HV000183: Unable to load
      'javax.el.ExpressionFactory'

根因:
Spring Boot 1.x 中验证框架由 spring-boot-starter-web 传递包含；
Boot 2.x 将其分离为独立 starter，需显式声明。

解决:
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

**案例 21: Hibernate sessionFactory/entityManagerFactory 双 Bean 冲突**

```
错误: NoUniqueBeanDefinitionException: No qualifying bean of type
      'javax.persistence.EntityManagerFactory' available: expected single
      matching bean but found 2: sessionFactory,entityManagerFactory

根因:
Hibernate 5.2+ 中 SessionFactory 扩展了 EntityManagerFactory 接口。
如果同时定义了 sessionFactory 和 entityManagerFactory 两个 Bean 且类型
都是 EntityManagerFactory，Spring 无法确定注入哪个。

解决:
// 保留 entityManagerFactory，添加兼容 bean 通过 unwrap
@Bean
public SessionFactory sessionFactory(EntityManagerFactory emf) {
    return emf.unwrap(SessionFactory.class);  // unwrap 返回的是 SessionFactory 而非 EntityManagerFactory
}
```

**案例 22: Hibernate EntityManagerHolder 转型失败**

```
错误: org.springframework.orm.jpa.EntityManagerHolder cannot be cast to
      org.springframework.orm.hibernate5.SessionHolder

根因:
同一个事务中 JPA 配置和 Hibernate 配置冲突。例如:
- XML 中配置了 HibernateTransactionManager
- Spring Boot 自动配置了 JpaTransactionManager
两者使用不同的资源持有者类型（EntityManagerHolder vs SessionHolder）。

解决:
  - 统一使用 JPA 配置，避免同时使用 JPA + Hibernate 原生 API
  - 或排除 HibernateJpaAutoConfiguration，仅保留 Hibernate 原生配置
# application.properties
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
```

**案例 23: Hibernate @SequenceGenerator allocationSize 不匹配**

```
错误: org.hibernate.MappingException: The increment size of the [SEQ_XXX]
      sequence is set to [50] in the entity mapping while the associated
      database sequence increment size is [1]

根因:
@SequenceGenerator 的 allocationSize 默认值为 50，但数据库中对应序列
的 INCREMENT BY 为 1。Hibernate 5.x 在启动时做严格校验，发现步长不匹配
则抛 MappingException。

解决:
@SequenceGenerator(name = "SEQ_GEN", sequenceName = "SEQ_XXX", allocationSize = 1)
// 或
@GeneratedValue(strategy = GenerationType.IDENTITY)  // 使用自增主键
```

**案例 24: Druid keepAlive 参数校验**

```
错误: java.sql.SQLException: keepAliveBetweenTimeMillis must be greater
      than timeBetweenEvictionRunsMillis

根因:
Druid 1.2.x 新增参数校验，要求 keepAliveBetweenTimeMillis（默认 120000）
必须大于 timeBetweenEvictionRunsMillis（默认 60000）。Spring Boot 2.x 中
timeBetweenEvictionRunsMillis 默认值可能被增大导致校验失败。

解决:
# 调大 keepAliveBetweenTimeMillis 或调小 timeBetweenEvictionRunsMillis
spring.datasource.druid.keepAliveBetweenTimeMillis=120000
spring.datasource.druid.timeBetweenEvictionRunsMillis=60000
# 如果不需要 keepAlive 功能，可以关闭
spring.datasource.druid.keepAlive=false
```

**案例 25: XStream 1.4.18+ 安全白名单**

```
错误: com.thoughtworks.xstream.security.ForbiddenClassException

根因:
XStream 1.4.17 及之前版本使用默认黑名单拒绝已知危险类型；1.4.18 及之后
版本改为默认白名单，任何未显式允许的类型反序列化时抛出异常。

解决:
XStream xstream = new XStream();
// 1.4.18+ 必须显式初始化安全框架
XStream.setupDefaultSecurity(xstream);
// 添加允许反序列化的类型
xstream.allowTypes(new Class[]{MyClass.class, OtherClass.class});
// 或允许类型通配
xstream.allowTypesByWildcard(new String[]{"com.myapp.**"});
```

**案例 26: Spring Boot 2.x 包名/API 变更**

```
错误: 编译错误 — 找不到类或方法

常见变更:

1. SpringBootServletInitializer 包名变更:
   // 1.x
   import org.springframework.boot.web.support.SpringBootServletInitializer;
   // 2.x
   import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

2. WebMvcConfigurerAdapter 废弃:
   // 1.x — 继承类
   public class WebConfig extends WebMvcConfigurerAdapter { }
   // 2.x — 实现接口（Java 8 默认方法）
   public class WebConfig implements WebMvcConfigurer { }

3. server.session.timeout 路径变更:
   // 1.x
   server.session.timeout=3600
   // 2.x
   server.servlet.session.timeout=30m   // 单位由秒变为 Duration
   // 代码中获取:
   // 1.x: serverProperties.getSession().getTimeout()
   // 2.x: serverProperties.getServlet().getSession().getTimeout()

4. logging 路径变更:
   // 1.x
   logging.path=/app/logs
   // 2.x
   logging.file.path=/app/logs
```
