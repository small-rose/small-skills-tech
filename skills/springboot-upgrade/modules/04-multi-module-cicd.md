# 第七步：多模块项目升级策略

#### 7.1 模块升级顺序

```yaml
multi_module_strategy:
  
  upgrade_order:
    
    step_1: "公共模块"
      modules:
        - "common"
        - "utils"
        - "api (接口定义)"
      effort: "低"
      risk: "低"
      notes: "通常不依赖Spring，先升级依赖版本"
      
    step_2: "数据层模块"
      modules:
        - "dao"
        - "repository"
        - "mapper"
      effort: "中"
      risk: "中"
      notes: "验证数据库访问兼容性"
      
    step_3: "服务层模块"
      modules:
        - "service"
        - "business"
      effort: "中"
      risk: "中"
      notes: "验证业务逻辑"
      
    step_4: "Web层模块"
      modules:
        - "controller"
        - "web"
        - "api-gateway"
      effort: "中"
      risk: "中"
      notes: "验证接口"
      
    step_5: "启动模块"
      modules:
        - "application"
        - "boot"
        - "main"
      effort: "低"
      risk: "低"
      notes: "最后调整启动配置"
      
  dependency_management:
    
    bom_import: |
      <dependencyManagement>
          <dependencies>
              <dependency>
                  <groupId>org.springframework.boot</groupId>
                  <artifactId>spring-boot-dependencies</artifactId>
                  <version>{version}</version>
                  <type>pom</type>
                  <scope>import</scope>
              </dependency>
          </dependencies>
      </dependencyManagement>
      
    version_override: |
      <properties>
          <mybatis.version>3.0.x</mybatis.version>
      </properties>
```

#### 7.2 模块间依赖处理

```yaml
inter_module_dependency:
  
  issues:
    
    - issue: "版本不一致"
      solution: "使用BOM统一管理版本"
      
    - issue: "API变更影响"
      solution: "先升级API提供方，再升级消费方"
      
    - issue: "配置冲突"
      solution: "明确模块边界，避免配置覆盖"
```

---

# 第八步：CI/CD与部署调整

#### 8.1 构建配置调整

```yaml
build_config:
  
  maven:
    plugin_upgrade: |
      <plugin>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-maven-plugin</artifactId>
          <version>{boot_version}</version>
      </plugin>
      
    packaging:
      jar: "默认，推荐"
      war: "需要外部容器时使用"
      war_config: |
        <packaging>war</packaging>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency>
        
  gradle:
    plugin_upgrade: |
      plugins {
          id 'org.springframework.boot' version '{version}'
      }
```

#### 8.2 Docker镜像调整

```yaml
docker_config:
  
  base_image:
    java_8: "eclipse-temurin:8-jre-alpine"
    java_17: "eclipse-temurin:17-jre-alpine"
    java_21: "eclipse-temurin:21-jre-alpine"
    
  multi_stage_build: |
    FROM eclipse-temurin:17-jdk-alpine AS builder
    WORKDIR /app
    COPY . .
    RUN ./mvnw package -DskipTests
    
    FROM eclipse-temurin:17-jre-alpine
    WORKDIR /app
    COPY --from=builder /app/target/*.jar app.jar
    ENTRYPOINT ["java", "-jar", "app.jar"]
    
  jib_config: |
    <plugin>
        <groupId>com.google.cloud.tools</groupId>
        <artifactId>jib-maven-plugin</artifactId>
        <version>3.3.0</version>
        <configuration>
            <from>
                <image>eclipse-temurin:17-jre-alpine</image>
            </from>
        </configuration>
    </plugin>
```

#### 8.3 启动脚本调整

```yaml
startup_script:
  
  legacy: |
    #!/bin/bash
    java -jar app.war
    
  spring_boot: |
    #!/bin/bash
    java -jar app.jar \
      --server.port=8080 \
      --spring.profiles.active=prod
      
  with_jvm_options: |
    #!/bin/bash
    java -Xms512m -Xmx1024m \
      -XX:+UseG1GC \
      -Dspring.profiles.active=prod \
      -jar app.jar
      
  health_check: |
    #!/bin/bash
    curl -f http://localhost:8080/actuator/health || exit 1
```

#### 8.4 监控与健康检查

```yaml
monitoring:
  
  actuator_config: |
    management:
      endpoints:
        web:
          exposure:
            include: health,info,metrics,prometheus
      endpoint:
        health:
          show-details: always
  
  health_check_url: "/actuator/health"
  
  prometheus: |
    management:
      metrics:
        export:
          prometheus:
            enabled: true
```
