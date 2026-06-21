# FMS项目 webapp目录升级处理指南

> **文档版本**: v1.0  
> **生成时间**: 2026年6月19日  
> **适用场景**: Spring Boot 2.7.18升级过程中webapp目录的处理

---

## 目录

1. [webapp目录结构分析](#1-webapp目录结构分析)
2. [XML配置文件加载策略](#2-xml配置文件加载策略)
3. [各类XML处理方案详解](#3-各类xml处理方案详解)
4. [静态资源处理](#4-静态资源处理)
5. [最终目录结构建议](#5-最终目录结构建议)
6. [完整配置示例](#6-完整配置示例)

---

## 1. webapp目录结构分析

### 1.1 当前目录结构

```
src/main/webapp/
├── *.html                          # 登录页面、错误页面
├── *.jsp                           # JSP页面（兼容）
├── *.js                            # jQuery、EasyUI等前端库
├── *.css                           # 样式文件
├── img/                            # 图片资源
└── WEB-INF/
    ├── web.xml                     # Web应用描述符
    ├── weblogic.xml                # WebLogic配置
    ├── bes-web.xml                 # BES容器配置
    └── dorado-home/                # Dorado框架配置目录
        ├── application-context.xml # Spring主配置（入口）
        ├── context.xml             # Dorado上下文（引用application-context.xml）
        ├── datasource.spring.xml   # 数据源配置
        ├── context-cache.spring.xml# 缓存配置（EhCache+Redis）
        ├── context-rabbitmq.spring.xml # RabbitMQ配置
        ├── schedule-context.xml    # 定时任务配置
        ├── servlet-context.xml     # Servlet配置
        ├── solr.spring.xml         # Solr配置
        ├── webservice.spring.xml   # WebService配置
        ├── workflow-context.xml    # 工作流配置
        ├── callcenter-config.xml   # CallCenter配置
        ├── datahub_server.spring.xml # 数据中心配置
        ├── marshaller.xml          # XML Marshaller配置
        ├── packages-config.xml     # 包扫描配置
        ├── configure.properties    # Dorado配置
        ├── configure-debug.properties # Dorado调试配置
        └── resources/              # Dorado资源文件
```

### 1.2 XML配置文件依赖关系

```
context.xml
    └── import → application-context.xml
                    ├── import → datahub_server.spring.xml
                    ├── import → marshaller.xml
                    ├── import → datasource.spring.xml
                    ├── import → solr.spring.xml
                    ├── import → schedule-context.xml
                    ├── import → webservice.spring.xml
                    │              └── import → cxf-servlet.xml (classpath)
                    ├── import → servlet-context.xml
                    ├── import → callcenter-config.xml
                    ├── import → context-cache.spring.xml
                    ├── import → pcipe-context.xml (classpath, 来自fndsoft)
                    ├── import → activiti-context.xml (classpath, 来自fndsoft)
                    ├── import → workflow-context.xml
                    └── import → common-context.xml (classpath, 来自dorado)
```

---

## 2. XML配置文件加载策略

### 2.1 Spring Boot加载webapp下XML的方式

#### 方式一：@ImportResource注解（推荐）

在启动类上使用`@ImportResource`注解显式导入XML配置：

```java
@SpringBootApplication
@ImportResource({
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
public class FmsApplication extends SpringBootServletInitializer {
    // ...
}
```

#### 方式二：ApplicationContextInitializer

创建自定义初始化器加载XML：

```java
public class DoradoContextInitializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {
    @Override
    public void initialize(ConfigurableApplicationContext applicationContext) {
        XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(applicationContext);
        reader.loadBeanDefinitions("file:src/main/webapp/WEB-INF/dorado-home/application-context.xml");
    }
}
```

#### 方式三：@Configuration类导入

```java
@Configuration
@ImportResource("file:src/main/webapp/WEB-INF/dorado-home/application-context.xml")
public class DoradoConfig {
}
```

### 2.2 路径配置对比

| 路径格式 | 适用场景 | 说明 |
|----------|---------|------|
| `file:src/main/webapp/...` | 本地开发 | 直接指定文件路径 |
| `classpath*:dorado-home/...` | 打包后运行 | 需将配置放入classpath |
| `classpath:dorado-home/...` | 打包后运行 | 单文件加载 |

---

## 3. 各类XML处理方案详解

### 3.1 核心Spring配置（application-context.xml）

#### 处理策略：**保持XML，通过@ImportResource加载**

**原因**：
- 包含12个子配置文件的import
- 包含大量Bean定义
- 修改为Java配置工作量巨大

**配置方式**：

```java
@SpringBootApplication
@ImportResource({
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
public class FmsApplication extends SpringBootServletInitializer {
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(FmsApplication.class);
    }
    
    public static void main(String[] args) {
        SpringApplication.run(FmsApplication.class, args);
    }
}
```

#### application-context.xml中的子配置加载

该文件通过`<import>`标签导入其他XML，Spring会自动处理相对路径：

```xml
<!-- application-context.xml 内容保持不变 -->
<import resource="datahub_server.spring.xml"/>      <!-- 相对路径 -->
<import resource="marshaller.xml"/>                  <!-- 相对路径 -->
<import resource="datasource.spring.xml"/>           <!-- 相对路径 -->
<import resource="solr.spring.xml"/>                 <!-- 相对路径 -->
<import resource="schedule-context.xml"/>            <!-- 相对路径 -->
<import resource="webservice.spring.xml"/>           <!-- 相对路径 -->
<import resource="servlet-context.xml"/>             <!-- 相对路径 -->
<import resource="callcenter-config.xml"/>           <!-- 相对路径 -->
<import resource="context-cache.spring.xml"/>        <!-- 相对路径 -->
<import resource="classpath*:pcipe-context.xml"/>    <!-- classpath -->
<import resource="classpath*:activiti-context.xml"/> <!-- classpath -->
<import resource="workflow-context.xml"/>            <!-- 相对路径 -->
<import resource="classpath:com/bstek/dorado/idesupport/common-context.xml"/> <!-- classpath -->
```

### 3.2 数据源配置（datasource.spring.xml）

#### 处理策略：**保持XML，随主配置一起加载**

**当前配置**：
```xml
<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="${jdbc.driverClass}" />
    <property name="url" value="${jdbc.url}" />
    <property name="username" value="${jdbc.username}" />
    <property name="password" value="${jdbc.password}" />
    <property name="initialSize" value="${jdbc.initialSize}" />
</bean>
```

**兼容性**：完全兼容，无需修改

### 3.3 缓存配置（context-cache.spring.xml）

#### 处理策略：**保持XML，需检查Redis连接工厂配置**

**需关注的配置**：
```xml
<!-- Redis连接工厂 - 需要适配Spring Data Redis 2.x -->
<bean id="jedisConnectionFactory" class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

**适配Spring Data Redis 2.x**：
```xml
<!-- 新增RedisStandaloneConfiguration -->
<bean id="redisStandaloneConfiguration" class="org.springframework.data.redis.connection.RedisStandaloneConfiguration">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
</bean>

<!-- 修改JedisConnectionFactory使用构造函数注入 -->
<bean id="jedisConnectionFactory" class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <constructor-arg ref="redisStandaloneConfiguration"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

### 3.4 RabbitMQ配置（context-rabbitmq.spring.xml）

#### 处理策略：**保持XML，修改Publisher Confirm配置**

**需关注的配置**：
```xml
<!-- 配置变化：publisher-confirms → publisher-confirm-type -->
<rabbit:connection-factory id="connectionFactory"
                           addresses="${rabbit.address}"
                           username="${rabbit.username}"
                           password="${rabbit.password}"
                           channel-cache-size="100" 
                           publisher-confirms="true"/>  <!-- 需要修改 -->
```

**适配Spring AMQP 2.x**：
```xml
<rabbit:connection-factory id="connectionFactory"
                           addresses="${rabbit.address}"
                           username="${rabbit.username}"
                           password="${rabbit.password}"
                           channel-cache-size="100" 
                           publisher-confirm-type="correlated"
                           publisher-returns="true"/>
```

### 3.5 定时任务配置（schedule-context.xml）

#### 处理策略：**完全保持，无需修改**

**原因**：
- 使用Spring提供的`MethodInvokingJobDetailFactoryBean`
- Quartz 2.3.2版本与Spring Boot 2.7.18兼容
- XML配置方式完全支持

**兼容性**：完全兼容

### 3.6 Servlet配置（servlet-context.xml）

#### 处理策略：**保持XML，需注意组件扫描**

**当前配置**：
```xml
<mvc:annotation-driven />
<context:component-scan base-package="com.cpic.fms.login.view">
    <context:include-filter type="annotation"
        expression="org.springframework.stereotype.Controller" />
</context:component-scan>
```

**兼容性**：完全兼容，无需修改

### 3.7 WebService配置（webservice.spring.xml）

#### 处理策略：**保持XML，检查CXF兼容性**

**当前配置**：
```xml
<import resource="classpath:META-INF/cxf/cxf-extension-xml.xml"/>
<import resource="classpath:META-INF/cxf/cxf-servlet.xml"/>
```

**兼容性**：CXF 3.1.4与Spring Boot 2.7.18兼容，无需修改

### 3.8 工作流配置（workflow-context.xml）

#### 处理策略：**完全保持，无需修改**

**原因**：
- 使用fndsoft-workflow-engine封装
- Activiti 5.16.3版本保持不变
- XML配置方式完全支持

### 3.9 Solr配置（solr.spring.xml）

#### 处理策略：**完全保持，无需修改**

**原因**：
- 使用Apache Solr SolrJ 4.5.0
- 与Spring版本无关
- XML配置方式完全支持

---

## 4. 静态资源处理

### 4.1 前端静态资源

#### 处理策略：**移动到resources/static目录**

**当前结构**：
```
src/main/webapp/
├── *.html          # 需要保留（JSP兼容）
├── *.jsp           # 需要保留（兼容）
├── *.js            # 需要移动
├── *.css           # 需要移动
└── img/            # 需要移动
```

**迁移方案**：

```
src/main/
├── resources/
│   └── static/              # 新增
│       ├── js/              # JavaScript文件
│       │   ├── jquery-3.7.1.js
│       │   ├── jquery.easyui.min.js
│       │   ├── sensors.js
│       │   └── ...
│       ├── css/             # 样式文件
│       │   └── login.css
│       ├── img/             # 图片资源
│       └── ...
└── webapp/                  # 保留JSP和HTML
    ├── *.html               # 保留
    ├── *.jsp                # 保留
    └── WEB-INF/
```

#### 配置application.properties

```properties
# 静态资源位置
spring.web.resources.static-locations=classpath:/static/,file:src/main/webapp/
```

### 4.2 Dorado View XML文件

**处理策略**：**保持原位，通过Dorado框架加载**

Dorado View XML文件（*.view.xml）由Dorado框架的`DoradoServlet`处理，保持在`src/main/webapp/`目录下即可。

---

## 5. 最终目录结构建议

### 5.1 推荐结构（最小改动）

```
fms/
├── pom.xml
├── src/main/
│   ├── java/
│   │   ├── com/
│   │   │   ├── FmsApplication.java          # 启动类（已改造）
│   │   │   └── cpic/fms/                    # 业务代码
│   │   └── fndsoft/rbac/                    # 权限模块
│   ├── resources/
│   │   ├── application.properties           # 新增：Boot配置
│   │   ├── logback.xml                      # 日志配置（可选）
│   │   └── static/                          # 新增：静态资源
│   │       ├── js/
│   │       ├── css/
│   │       └── img/
│   └── webapp/                              # 保留
│       ├── *.html                           # 保留：HTML页面
│       ├── *.jsp                            # 保留：JSP页面（兼容）
│       ├── WEB-INF/
│       │   ├── web.xml                      # 保留：Web描述符
│       │   └── dorado-home/                 # 保留：Dorado配置
│       │       ├── application-context.xml  # 保留：Spring主配置
│       │       ├── datasource.spring.xml    # 保留
│       │       ├── context-cache.spring.xml # 保留（需小改）
│       │       ├── context-rabbitmq.spring.xml # 保留（需小改）
│       │       ├── schedule-context.xml     # 保留
│       │       ├── servlet-context.xml      # 保留
│       │       ├── webservice.spring.xml    # 保留
│       │       ├── workflow-context.xml     # 保留
│       │       └── ...
│       └── img/                             # 保留：图片（兼容）
└── lib/                                     # 保留：本地JAR
```

### 5.2 application-context.xml导入路径

在`FmsApplication.java`中配置：

```java
@SpringBootApplication
@ImportResource({
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
@ComponentScan(basePackages = {"com.cpic.fms", "com.fndsoft"})
public class FmsApplication extends SpringBootServletInitializer {
    // ...
}
```

---

## 6. 完整配置示例

### 6.1 FmsApplication.java完整代码

```java
package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

/**
 * FMS应用启动类
 * 
 * 注意事项：
 * 1. 排除DataSourceAutoConfiguration，使用自定义数据源配置
 * 2. 通过@ImportResource加载webapp下的XML配置
 * 3. 继承SpringBootServletInitializer支持WAR部署
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
@ImportResource({
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
@ComponentScan(basePackages = {"com.cpic.fms", "com.fndsoft"})
@Configuration
public class FmsApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(FmsApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(FmsApplication.class, args);
    }
}
```

### 6.2 application.properties完整配置

```properties
# ========================
# Server Configuration
# ========================
server.port=8080
server.servlet.context-path=/
server.servlet.session.timeout=30m
server.servlet.session.cookie.name=FMSSESSIONID
server.servlet.session.cookie.http-only=true
server.servlet.session.cookie.secure=false

# Tomcat Configuration
server.tomcat.max-threads=200
server.tomcat.min-spare-threads=10
server.tomcat.max-connections=8192
server.tomcat.accept-count=100
server.tomcat.uri-encoding=UTF-8
server.tomcat.basedir=./tomcat-temp

# ========================
# Spring Configuration
# ========================
# 允许Bean定义覆盖（兼容XML中的同名Bean）
spring.main.allow-bean-definition-overriding=true

# 静态资源位置
spring.web.resources.static-locations=classpath:/static/

# 排除自动配置（使用自定义配置）
spring.autoconfigure.exclude=\
    org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
    org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
    org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,\
    org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration

# ========================
# Actuator Configuration
# ========================
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized
management.server.port=8081

# ========================
# Logging Configuration (可选，覆盖logback配置)
# ========================
# logging.level.root=INFO
# logging.level.com.cpic.fms=DEBUG
```

### 6.3 pom.xml中webapp资源配置

```xml
<build>
    <finalName>fms</finalName>
    <resources>
        <!-- Java源码中的XML和资源文件 -->
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.js</include>
                <include>**/*.css</include>
            </includes>
        </resource>
        <!-- Resources目录 -->
        <resource>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.bar</include>
                <include>**/*.drl</include>
                <include>**/*.bpmn</include>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
        </resource>
    </resources>
    <plugins>
        <!-- Spring Boot Maven插件 -->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <excludeSystemScope>true</excludeSystemScope>
            </configuration>
        </plugin>
        <!-- WAR插件 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-war-plugin</artifactId>
            <version>3.3.2</version>
            <configuration>
                <failOnMissingWebXml>false</failOnMissingWebXml>
                <warSourceDirectory>src/main/webapp</warSourceDirectory>
                <webResources>
                    <resource>
                        <directory>${project.basedir}/lib</directory>
                        <targetPath>WEB-INF/lib</targetPath>
                        <filtering>false</filtering>
                        <includes>
                            <include>**/*.jar</include>
                        </includes>
                    </resource>
                </webResources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

---

## 7. 关键问题解答

### Q1: web.xml还需要吗？

**A**: 保留但不是必须的。

- **保留原因**：Dorado 7框架的`DoradoServlet`和`DelegatingFilterProxy`通过web.xml配置
- **Spring Boot支持**：Boot 2.7.18支持web.xml，会自动检测并加载
- **建议**：保留web.xml，确保Dorado框架正常工作

### Q2: XML配置文件需要移动到classpath吗？

**A**: 不需要。

通过`file:`前缀可以直接加载webapp下的XML：
```java
@ImportResource("file:src/main/webapp/WEB-INF/dorado-home/application-context.xml")
```

### Q3: 如何处理classpath*:的XML导入？

**A**: application-context.xml中的以下导入会自动从classpath加载：
```xml
<import resource="classpath*:pcipe-context.xml"/>      <!-- 来自fndsoft JAR -->
<import resource="classpath*:activiti-context.xml"/>   <!-- 来自fndsoft JAR -->
```

这些文件打包在本地JAR中，Spring会自动从classpath加载。

### Q4: JSP页面还能用吗？

**A**: 可以，但需要额外配置。

添加JSP支持：
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-jasper</artifactId>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
</dependency>
```

```properties
# application.properties
spring.mvc.view.prefix=/WEB-INF/
spring.mvc.view.suffix=.jsp
```

### Q5: Dorado View文件如何加载？

**A**: 由DoradoServlet处理，无需额外配置。

Dorado View XML文件（*.view.xml）通过`web.xml`中配置的`DoradoServlet`加载：
```xml
<servlet>
    <servlet-name>doradoServlet</servlet-name>
    <servlet-class>com.bstek.dorado.web.servlet.DoradoServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>doradoServlet</servlet-name>
    <url-pattern>*.d</url-pattern>
</servlet-mapping>
```

### Q6: 如何验证XML加载成功？

**A**: 在启动日志中搜索以下关键信息：

```
Loading XML bean definitions from file [src/main/webapp/WEB-INF/dorado-home/application-context.xml]
Importing beans from: datasource.spring.xml
Importing beans from: context-cache.spring.xml
...
Started FmsApplication in XX.XX seconds
```

---

## 8. 常见问题排查

### 8.1 ClassNotFoundException

**问题**：启动时报`ClassNotFoundException`

**原因**：XML中引用的类在classpath中找不到

**解决**：检查pom.xml中相关依赖是否正确引入

### 8.2 BeanDefinitionOverrideException

**问题**：启动时报`BeanDefinitionOverrideException`

**原因**：XML和注解定义了同名Bean

**解决**：在application.properties中添加：
```properties
spring.main.allow-bean-definition-overriding=true
```

### 8.3 FileNotFoundException

**问题**：启动时报`FileNotFoundException: src/main/webapp/...`

**原因**：工作目录不正确

**解决**：确保从项目根目录启动，或使用绝对路径：
```java
@ImportResource("file:D:/dev-tools-JetBrains/idea-work/DongWu/fms/src/main/webapp/WEB-INF/dorado-home/application-context.xml")
```

### 8.4 Circular Reference

**问题**：启动时报`Circular reference detected`

**原因**：Spring Boot 2.6+默认禁止循环引用

**解决**：在application.properties中添加：
```properties
spring.main.allow-circular-references=true
```

---

**文档结束**

> **总结**：webapp目录下的XML配置文件**保持原位不动**，通过`@ImportResource("file:...")`方式加载即可。核心改造点在于启动类配置和少量XML属性调整。