# 第一步：工程信息采集

#### 1.1 自动采集清单

```yaml
auto_collection:
  
  # 构建工具
  build_tool:
    maven:
      check_file: "pom.xml"
      extract:
        - "parent.groupId, parent.artifactId, parent.version"
        - "properties中的版本定义"
        - "dependencies列表"
        - "plugins列表"
        
    gradle:
      check_file: "build.gradle"
      extract:
        - "plugins块"
        - "dependencies块"
        - "ext变量"
        
  # Java版本检测
  java_version:
    check_files: ["pom.xml", "build.gradle", ".java-version", "Dockerfile"]
    properties:
      maven: "maven.compiler.source, maven.compiler.target, java.version"
      gradle: "sourceCompatibility, targetCompatibility"
      
  # Spring版本检测
  spring_version:
    indicators:
      - "spring-core版本"
      - "spring-webmvc版本"
      - "spring-boot版本"
    xml_indicators:
      - "spring-beans.xml中的schema版本"
      - "web.xml中的版本声明"
```

#### 1.2 配置文件扫描

```yaml
config_scan:
  
  # 传统Spring MVC配置
  traditional_spring:
    xml_files:
      - pattern: "**/web.xml"
        location: "src/main/webapp/WEB-INF/"
        importance: "高"
      - pattern: "**/applicationContext*.xml"
        location: "src/main/resources/"
        importance: "高"
      - pattern: "**/spring*.xml"
        location: "src/main/resources/"
        importance: "高"
      - pattern: "**/spring-*.xml"
        location: "src/main/resources/"
        importance: "中"
        
  # Spring Boot配置
  spring_boot:
    config_files:
      - pattern: "**/application.yml"
      - pattern: "**/application.yaml"
      - pattern: "**/application.properties"
      - pattern: "**/application-*.yml"
      - pattern: "**/bootstrap.yml"
      - pattern: "**/bootstrap.properties"
```

#### 1.3 依赖分析

```yaml
dependency_analysis:
  
  # 必须识别的依赖类别
  categories:
    
    core_spring:
      - "spring-core"
      - "spring-beans"
      - "spring-context"
      - "spring-web"
      - "spring-webmvc"
      - "spring-aop"
      - "spring-aspects"
      
    database:
      - "spring-data-jpa"
      - "spring-data-redis"
      - "spring-data-mongodb"
      - "mybatis"
      - "mybatis-spring"
      - "hibernate-core"
      - "jdbc"
      - "hikari"
      
    middleware:
      - "spring-amqp"
      - "spring-kafka"
      - "spring-data-redis"
      - "lettuce"
      - "jedis"
      
    security:
      - "spring-security-core"
      - "spring-security-web"
      - "spring-security-config"
      - "spring-security-oauth2"
      
    view:
      - "thymeleaf"
      - "freemarker"
      - "jsp-api"
      - "jstl"
      
    test:
      - "spring-test"
      - "junit"
      - "mockito"
      - "hamcrest"
      
    utils:
      - "lombok"
      - "guava"
      - "commons-lang"
      - "commons-io"
      - "fastjson"
      - "jackson"
      
    internal:
      - "自定义groupId开头的依赖"
      - "公司内部组件"
      
  # 专有框架检测
  proprietary_framework:
    detection:
      - "web.xml中是否存在非标准Servlet（非DispatcherServlet）"
      - "是否存在自定义Servlet基类（继承HttpServlet而非Spring的DispatcherServlet）"
      - "JAR中是否包含框架专属的context.xml（如com/bstek/dorado/core/context.xml）"
      - "是否存在框架专属的Filter/Listener（如DelegatingFilterProxy、ServletContextListener）"
      - "是否存在WEB-INF/dorado-home或类似框架配置目录"
      - "项目中是否有大量*.view.xml或类似框架视图文件"
    risk_level: "high"
    note: "专有框架是整个升级过程中风险最高、耗时最长的环节，需优先评估"
```

---

#### 1.4 专有框架信息采集清单

```yaml
proprietary_framework_info:
  
  # 框架Servlet/Filter/Listener信息
  servlet_filter_listener:
    check_file: "web.xml"
    extract:
      - "所有<servlet>及其<servlet-class>、<init-param>、<load-on-startup>"
      - "所有<filter>及其<filter-class>、<init-param>"
      - "所有<listener>及其<listener-class>"
      - "所有<servlet-mapping>及其URL模式"
      
  # 框架JAR内部Context信息
  framework_context:
    method: "解压框架JAR，扫描以下路径"
    check_locations:
      - "META-INF/dorado-package.properties（Dorado package定义）"
      - "com/**/context.xml（框架Context配置）"
      - "com/**/servlet-context.xml（框架Servlet子Context配置）"
    extract:
      - "所有Context XML的依赖关系（import层次）"
      - "Context中定义的Bean名称和类"
      - "哪些Bean定义了占位符（${...}）"
      
  # 全局状态初始化
  global_state:
    check_class: ["框架Servlet.class", "框架Listener.class"]
    extract:
      - "静态字段初始化方式"
      - "ServletContext属性使用情况"
      - "自定义配置存储类（如Configure Store）"
      - "init-param vs 配置存储的读取优先级"
      
  # 框架配置目录
  framework_config_dir:
    check_paths:
      - "WEB-INF/dorado-home/**"
      - "WEB-INF/framework-config/**"
    extract:
      - "配置文件清单"
      - "properties文件中的占位符（这些可能由框架的PropertyPlaceholderConfigurer处理）"
      - "框架运行模式配置"
```

# 第二步：升级类型判断与策略选择

#### 2.1 升级类型矩阵

| 特征 | 传统Servlet | 传统Spring MVC | Spring Boot |
|------|------------|----------------|-------------|
| 构建产物 | war包 | war包 | jar/war包 |
| 配置方式 | web.xml | web.xml + XML | application.yml |
| 启动方式 | 容器部署 | 容器部署 | 内嵌Tomcat |
| 依赖管理 | 手动管理 | 手动管理 | starter |
| 配置文件位置 | WEB-INF | classpath | classpath |
| 注解支持 | Servlet 3.0+ | 完整 | 完整 |
| 自动配置 | 无 | 无 | 有 |

#### 2.2 传统Servlet → Spring Boot 迁移策略

```yaml
servlet_migration:
  
  prerequisite:
    - "先迁移到Spring MVC（或直接迁移到Spring Boot）"
    
  direct_to_boot:
    name: "直接迁移到Spring Boot"
    effort: "高"
    risk: "高"
    steps:
      - "添加spring-boot-starter-web依赖"
      - "移除所有web.xml配置"
      - "创建@SpringBootApplication启动类"
      - "将Servlet配置转为@Configuration类"
      - "将Filter配置转为FilterRegistrationBean"
      - "将Listener配置转为@EventListener"
      
  via_spring_mvc:
    name: "先迁移到Spring MVC再迁移到Spring Boot"
    effort: "中"
    risk: "中"
    steps:
      - "添加Spring MVC依赖"
      - "创建DispatcherServlet配置"
      - "将Servlet迁移到@Controller"
      - "验证Spring MVC正常工作"
      - "再按Spring MVC升级策略操作"
```

#### 2.3 传统Spring MVC → Spring Boot 迁移策略

```yaml
springmvc_to_boot:
  
  # 核心改造点
  core_changes:
    
    web_xml_removal:
      from: "web.xml"
      to: "@Configuration + @Bean"
      effort: "2-4h"
      risk: "medium"
      
    dispatcher_config:
      from: "spring-mvc.xml中的mvc:annotation-driven"
      to: "@EnableWebMvc 或 自动配置"
      effort: "1-2h"
      risk: "low"
      
    component_scan:
      from: "XML中的context:component-scan"
      to: "@ComponentScan或@SpringBootApplication自动扫描"
      effort: "0.5h"
      risk: "low"
      
  # 常见web.xml元素迁移映射
  webxml_mapping:
    
    DispatcherServlet:
      xml: |
        <servlet>
            <servlet-name>dispatcher</servlet-name>
            <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
            <init-param>
                <param-name>contextConfigLocation</param-name>
                <param-value>/WEB-INF/spring-mvc.xml</param-value>
            </init-param>
            <load-on-startup>1</load-on-startup>
        </servlet>
        <servlet-mapping>
            <servlet-name>dispatcher</servlet-name>
            <url-pattern>/</url-pattern>
        </servlet-mapping>
      java_config: |
        # Spring Boot自动配置，无需手动配置
        # 如需自定义：
        @Configuration
        @EnableWebMvc
        public class WebConfig implements WebMvcConfigurer {
            // 自定义配置
        }
        
    ContextLoaderListener:
      xml: |
        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/applicationContext.xml</param-value>
        </context-param>
        <listener>
            <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
        </listener>
      java_config: |
        @SpringBootApplication
        @ImportResource({"classpath:applicationContext.xml"})
        public class Application {
            public static void main(String[] args) {
                SpringApplication.run(Application.class, args);
            }
        }
        
    CharacterEncodingFilter:
      xml: |
        <filter>
            <filter-name>characterEncodingFilter</filter-name>
            <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
            <init-param>
                <param-name>encoding</param-name>
                <param-value>UTF-8</param-value>
            </init-param>
            <init-param>
                <param-name>forceEncoding</param-name>
                <param-value>true</param-value>
            </init-param>
        </filter>
        <filter-mapping>
            <filter-name>characterEncodingFilter</filter-name>
            <url-pattern>/*</url-pattern>
        </filter-mapping>
      java_config: |
        # Spring Boot自动配置UTF-8编码
        # 如需自定义：
        @Bean
        public FilterRegistrationBean<CharacterEncodingFilter> characterEncodingFilter() {
            FilterRegistrationBean<CharacterEncodingFilter> registration = new FilterRegistrationBean<>();
            CharacterEncodingFilter filter = new CharacterEncodingFilter();
            filter.setEncoding("UTF-8");
            filter.setForceEncoding(true);
            registration.setFilter(filter);
            registration.addUrlPatterns("/*");
            return registration;
        }
```

#### 2.4 Spring Boot版本升级策略

```yaml
boot_upgrade_strategy:
  
  # 版本升级路径决策
  path_decision:
    
    boot_1_to_2:
      from: "1.x"
      to: "2.7.x"
      effort: "高"
      duration: "2-4周"
      key_changes:
        - "Spring 4.x → 5.x"
        - "大量API变更"
        - "配置属性名变更"
        - "Actuator端点路径变更"
      recommendation: "建议直接跳到2.7.x"
      
    boot_2_to_3:
      from: "2.x"
      to: "3.2.x"
      effort: "很高"
      duration: "4-8周"
      key_changes:
        - "Java 17基线要求"
        - "javax → jakarta包名变更"
        - "Spring Security 6.x重构"
        - "Hibernate 6.x变更"
        - "Spring Data主要版本更新"
      recommendation: "需要充分评估，建议分阶段"
      
    boot_incremental:
      from: "3.0/3.1"
      to: "3.2.x"
      effort: "低"
      duration: "1-3天"
      key_changes:
        - "小版本API兼容"
        - "依赖版本升级"
      recommendation: "风险最低，建议保持"
```

---

# 第三步：版本发布时间线与支持周期

#### 3.1 Spring Boot版本历史

```yaml
version_timeline:
  
  spring_boot_1:
    versions:
      1_0: { release: "2014-04", eol: "2016-01", java: "6+" }
      1_1: { release: "2014-07", eol: "2016-04", java: "6+" }
      1_2: { release: "2014-12", eol: "2016-09", java: "6+" }
      1_3: { release: "2015-11", eol: "2017-04", java: "6+" }
      1_4: { release: "2016-07", eol: "2017-12", java: "7+" }
      1_5: { release: "2017-01", eol: "2019-08", java: "7+" }
    status: "已停止维护"
    recommendation: "必须升级"
    
  spring_boot_2:
    versions:
      2_0: { release: "2018-03", eol: "2019-10", java: "8+" }
      2_1: { release: "2018-10", eol: "2020-10", java: "8+" }
      2_2: { release: "2019-10", eol: "2021-11", java: "8+" }
      2_3: { release: "2020-05", eol: "2021-11", java: "8+" }
      2_4: { release: "2020-11", eol: "2021-11", java: "8+" }
      2_5: { release: "2021-05", eol: "2022-11", java: "8+" }
      2_6: { release: "2021-11", eol: "2022-11", java: "8+" }
      2_7: { release: "2022-05", eol: "2023-11", java: "8+" }
    status: "2.7.x已停止维护"
    recommendation: "新项目建议使用3.x"
    
  spring_boot_3:
    versions:
      3_0: { release: "2022-11", eol: "2023-11", java: "17+" }
      3_1: { release: "2023-05", eol: "2024-05", java: "17+" }
      3_2: { release: "2023-11", eol: "2025-02", java: "17+" }
      3_3: { release: "2024-05", eol: "2025-11", java: "17+" }
      3_4: { release: "2024-11", eol: "2026-05", java: "17+" }
    status: "活跃维护"
    recommendation: "推荐3.2.x或3.3.x"
    
  # 当前推荐版本
  current_recommendation:
    production: "3.2.x"
    latest: "3.3.x"
    legacy: "2.7.x (仅维护现有项目)"
```

#### 3.2 Spring Cloud版本矩阵

```yaml
spring_cloud_compatibility:
  
  # Spring Cloud与Spring Boot版本对应关系
  version_matrix:
    
    spring_cloud_2021:
      boot_versions: ["2.6.x", "2.7.x"]
      java: "8+"
      modules:
        - "spring-cloud-starter-gateway"
        - "spring-cloud-starter-netflix-eureka-client"
        - "spring-cloud-starter-config"
        
    spring_cloud_2022:
      boot_versions: ["3.0.x", "3.1.x"]
      java: "17+"
      modules:
        - "spring-cloud-starter-gateway"
        - "spring-cloud-starter-netflix-eureka-client"
        - "spring-cloud-starter-config"
        
    spring_cloud_2023:
      boot_versions: ["3.2.x", "3.3.x"]
      java: "17+"
      modules:
        - "spring-cloud-starter-gateway"
        - "spring-cloud-starter-netflix-eureka-client"
        - "spring-cloud-starter-config"
```

#### 3.3 热门Spring Boot版本组件版本组合表

| 组件 | Boot 1.5.13 | Boot 2.5.13 | Boot 2.7.18 | Boot 3.2.x | Boot 3.5.x |
|------|-------------|-------------|-------------|-------------|-------------|
| **Java基线** | 7+ | 8+ | 8+ | 17+ | 17+ |
| **Spring Framework** | 4.3.17 | 5.3.31 | 5.3.39 | 6.1.x | 6.2.x |
| **Hibernate** | 5.0.12 | 5.4.33 | 5.6.15 | 6.4.x | 6.6.x |
| **Spring Data** | 1.11.x | 2.5.x | 2.7.x | 3.2.x | 3.4.x |
| **Tomcat** | 8.5.20 | 9.0.75 | 9.0.82 | 10.1.x | 10.1.x |
| **Jackson** | 2.8.x | 2.13.x | 2.14.x | 2.15.x | 2.17.x |
| **SLF4J** | 1.7.x | 1.7.x | 1.7.x | 2.0.x | 2.0.x |
| **Logback** | 1.1.x | 1.2.x | 1.2.x | 1.4.x | 1.5.x |
| **JUnit** | 4.12 | 5.7.x | 5.8.x | 5.10.x | 5.11.x |
| **Mockito** | 1.10.x | 3.9.x | 3.11.x | 5.7.x | 5.14.x |
| **MySQL驱动** | 5.1.x | 8.0.x | 8.0.x | 8.0.x | 8.4.x |
| **HikariCP** | 2.5.x | 4.0.x | 5.0.x | 5.1.x | 6.2.x |

**使用说明：**
- 此表为典型组合版本，具体版本取决于Spring Boot BOM管理
- 实际项目请以 `pom.xml` 或 `gradle.properties` 中的版本为准
- 升级时建议保持同一主版本内的组件版本一致

```yaml
# 快速查看当前项目依赖版本
# Maven
mvn dependency:tree -Dincludes=org.hibernate:*:*:*

# Gradle
./gradle dependencies --configuration runtimeClasspath | grep hibernate
```
