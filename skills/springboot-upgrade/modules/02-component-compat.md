# 第四步：组件兼容性深度分析

#### 4.1 数据库组件兼容性

```yaml
database_compatibility:
  
  relational:
    
    mysql:
      driver: "mysql-connector-java"
      compatibility:
        boot_2_7: { driver: "8.0.x", notes: "推荐8.0.33+" }
        boot_3_0: { driver: "8.0.x", notes: "使用com.mysql.cj.jdbc.Driver" }
        boot_3_2: { driver: "8.0.x/8.2.x", notes: "" }
      common_issues:
        - "时区问题：serverTimezone=UTC"
        - "SSL配置变更"
        - "连接池参数调整"
        
    postgresql:
      driver: "postgresql"
      compatibility:
        boot_2_7: { driver: "42.x" }
        boot_3_0: { driver: "42.x" }
        boot_3_2: { driver: "42.x" }
      
    oracle:
      driver: "ojdbc8"
      compatibility:
        boot_2_7: { driver: "19.x/21.x" }
        boot_3_0: { driver: "21.x" }
        boot_3_2: { driver: "23.x" }
        
    h2:
      driver: "h2"
      compatibility:
        boot_2_7: { driver: "1.4.x/2.x" }
        boot_3_0: { driver: "2.x" }
        boot_3_2: { driver: "2.x" }
        
  orm:
    
    mybatis:
      starter: "mybatis-spring-boot-starter"
      compatibility:
        boot_2_7: { version: "2.3.x" }
        boot_3_0: { version: "3.0.x" }
        boot_3_2: { version: "3.0.x" }
      key_changes:
        - "包名从org.mybatis.spring.boot变更"
        - "配置属性前缀可能变更"
        
    mybatis_plus:
      starter: "mybatis-plus-boot-starter"
      compatibility:
        boot_2_7: { version: "3.5.x" }
        boot_3_0: { version: "3.5.x+" }
        boot_3_2: { version: "3.5.5+" }
      notes: "检查mybatis-plus-extension版本"
      
    hibernate:
      current_version: "5.4.33.Final"
      release_history:
        5_4: { release: "2018-12", eol: "2022-01", java: "8+", jpa: "2.2" }
        5_5: { release: "2021-06", eol: "2021-12", java: "8+", jpa: "2.2", notes: "引入Jakarta支持" }
        5_6: { release: "2021-10", eol: "2023-02", java: "8+", jpa: "2.2", notes: "最后一个5.x版本" }
        6_0: { release: "2022-04", eol: "2022-06", java: "11+", jpa: "3.0", notes: "重大重构" }
        6_1: { release: "2022-06", eol: "2023-03", java: "11+", jpa: "3.0" }
        6_2: { release: "2023-03", eol: "2026-05", java: "11+", jpa: "3.1" }
        6_4: { release: "2023-11", eol: "2024-08", java: "17+", jpa: "3.1" }
        6_6: { release: "2024-08", eol: "2026-06", java: "17+", jpa: "3.2", notes: "当前稳定版" }
        7_0: { release: "2025-05", eol: "2025-08", java: "17+", jpa: "3.2", notes: "Apache License" }
      compatibility:
        boot_2_7: { version: "5.6.x", notes: "使用javax.persistence，推荐升级到5.6.15.Final" }
        boot_3_0: { version: "6.1.x", notes: "使用jakarta.persistence" }
        boot_3_2: { version: "6.4.x", notes: "" }
        boot_3_3: { version: "6.6.x", notes: "推荐使用" }
      upgrade_path: "5.4.x → 5.6.x → 6.0.x → 6.2.x → 6.4.x → 6.6.x"
      key_changes:
        - "5.4→5.5: 引入Jakarta命名空间支持（通过-jakarta后缀）"
        - "5.5→5.6: 移除Javassist，性能优化"
        - "5.6→6.0: javax.persistence → jakarta.persistence，重大API变更"
        - "6.0→6.2: HQL改进，多租户增强"
        - "6.2→6.4: 软删除支持，数组函数"
        - "6.4→6.6: Jakarta Data支持"
      risk_level: "high"
      
    spring_data_jpa:
      current_version: "1.13.12.RELEASE"
      release_history:
        1_13: { release: "2016-12", spring: "4.2.x", java: "7+", notes: "非常旧的版本" }
        2_0: { release: "2017-10", spring: "5.0.x", java: "8+" }
        2_1: { release: "2018-07", spring: "5.1.x", java: "8+" }
        2_2: { release: "2019-06", spring: "5.2.x", java: "8+" }
        2_3: { release: "2020-04", spring: "5.3.x", java: "8+" }
        2_7: { release: "2022-03", spring: "5.3.x", java: "8+", notes: "Spring Boot 2.7默认" }
        3_0: { release: "2022-11", spring: "6.0.x", java: "17+", notes: "Jakarta命名空间" }
        3_1: { release: "2023-05", spring: "6.1.x", java: "17+" }
        3_2: { release: "2023-11", spring: "6.1.x", java: "17+", notes: "Spring Boot 3.2默认" }
        3_5: { release: "2024-04", spring: "6.2.x", java: "17+", notes: "当前稳定版" }
        4_0: { release: "2025-11", spring: "6.2.x", java: "17+", notes: "最新版本" }
      compatibility:
        boot_2_7: { version: "2.7.x", notes: "" }
        boot_3_0: { version: "3.0.x", notes: "需要升级" }
        boot_3_2: { version: "3.2.x", notes: "" }
        boot_3_3: { version: "3.5.x", notes: "推荐" }
      upgrade_path: "1.13.x → 2.0.x → 2.7.x → 3.0.x → 3.2.x → 3.5.x"
      key_changes:
        - "1.13→2.0: Spring 5.x兼容，新特性"
        - "2.0→2.7: 持续改进"
        - "2.7→3.0: javax → jakarta"
        - "3.0→3.5: 持续改进"
      risk_level: "medium"
```

#### 4.2 中间件兼容性

```yaml
middleware_compatibility:
  
  cache:
    
    ehcache:
      current_version: "2.6.9"
      artifact: "net.sf.ehcache:ehcache"
      release_history:
        2_6: { release: "2012", eol: "2016", java: "6+", notes: "非常旧的版本" }
        2_7: { release: "2014", eol: "2018", java: "6+", notes: "最后的2.x版本" }
        3_0: { release: "2016-04", eol: "2017", java: "8+", notes: "完全重写，新API" }
        3_5: { release: "2018-02", eol: "2018-09", java: "8+" }
        3_9: { release: "2020-08", eol: "2023-02", java: "8+" }
        3_10: { release: "2022-03", eol: "2023", java: "8+" }
        3_11: { release: "2025-08", eol: null, java: "8+", notes: "最后一个支持Java 8的版本" }
        3_12: { release: "2026-04", eol: null, java: "17+", notes: "最新版本，Java 17+" }
      compatibility:
        boot_2_7: { version: "2.10.x/3.9.x", notes: "2.x需要ehcache依赖，3.x支持JSR-107" }
        boot_3_0: { version: "3.10.x", notes: "推荐3.x" }
        boot_3_2: { version: "3.10.x/3.11.x", notes: "" }
        boot_3_3: { version: "3.11.x", notes: "推荐" }
      upgrade_path: "2.6.x → 2.10.x → 3.10.x → 3.11.x"
      key_changes:
        - "2.x→3.x: 完全重写，API不兼容"
        - "3.x: 支持JSR-107 (JCache)"
        - "3.11→3.12: Java 17基线要求"
      migration_notes: |
        # Ehcache 2.x到3.x迁移
        1. 配置文件格式变更（XML Schema变更）
        2. CacheManager初始化方式变更
        3. 缓存操作API变更
        4. 建议同时引入spring-boot-starter-cache
      risk_level: "medium"
      
    redis:
      starter: "spring-boot-starter-data-redis"
      clients:
        lettuce:
          current_spring_boot_default: true
          release_history:
            6_0: { release: "2019-10", java: "8+", notes: "引入响应式支持" }
            6_1: { release: "2020-09", java: "8+" }
            6_2: { release: "2022-04", java: "8+", notes: "Spring Boot 2.7默认" }
            6_3: { release: "2023-06", java: "8+", notes: "Spring Boot 3.1默认" }
            7_0: { release: "2025-10", java: "8+", notes: "最新稳定版" }
          compatibility:
            boot_2_7: { version: "6.1.x/6.2.x" }
            boot_3_0: { version: "6.2.x" }
            boot_3_2: { version: "6.3.x" }
            boot_3_3: { version: "7.0.x" }
          notes: "Spring Boot默认客户端，推荐使用"
          
        jedis:
          current_version: "2.9.0"
          release_history:
            2_9: { release: "2017", java: "7+", notes: "非常旧的版本" }
            3_0: { release: "2019-03", java: "8+" }
            3_7: { release: "2021", java: "8+", notes: "Spring Boot 2.7管理" }
            4_0: { release: "2023-09", java: "8+", notes: "重大更新" }
            5_0: { release: "2023-10", java: "8+" }
            5_1: { release: "2023-11", java: "8+" }
            5_2: { release: "2024-09", java: "8+" }
            6_0: { release: "2025-04", java: "8+" }
            7_0: { release: "2025-10", java: "8+" }
          compatibility:
            boot_2_7: { version: "3.7.x/3.8.x" }
            boot_3_0: { version: "4.x/5.0.x" }
            boot_3_2: { version: "5.1.x" }
            boot_3_3: { version: "5.2.x" }
          notes: "同步客户端，如需使用需手动配置"
          
    caffeine:
      starter: "spring-boot-starter-cache"
      compatibility:
        boot_2_7: { version: "2.9.x" }
        boot_3_0: { version: "2.10.x" }
        boot_3_2: { version: "3.1.x" }
        
  messaging:
    
    rabbitmq:
      starter: "spring-boot-starter-amqp"
      compatibility:
        boot_2_7: { spring_amqp: "2.4.x" }
        boot_3_0: { spring_amqp: "3.0.x" }
        boot_3_2: { spring_amqp: "3.1.x" }
      notes: "AMQP客户端版本兼容性较好"
      
    kafka:
      starter: "spring-boot-starter-kafka"
      compatibility:
        boot_2_7: { spring_kafka: "2.8.x", kafka_client: "3.0.x" }
        boot_3_0: { spring_kafka: "3.0.x", kafka_client: "3.3.x" }
        boot_3_2: { spring_kafka: "3.1.x", kafka_client: "3.6.x" }
      notes: "Spring Kafka版本与Boot版本绑定"
      
    rocketmq:
      starter: "rocketmq-spring-boot-starter"
      compatibility:
        boot_2_7: { version: "2.2.x" }
        boot_3_0: { version: "2.3.x" }
      notes: "第三方starter，需要单独验证"
      
  elasticsearch:
    starter: "spring-boot-starter-data-elasticsearch"
    compatibility:
      boot_2_7: { elasticsearch: "7.17.x" }
      boot_3_0: { elasticsearch: "8.x" }
      boot_3_2: { elasticsearch: "8.x" }
    notes: "ES 7.x到8.x有较大API变更"
```

#### 4.3 安全组件兼容性

```yaml
security_compatibility:
  
  spring_security:
    compatibility:
      boot_2_7: 
        version: "5.7.x"
        config: "WebSecurityConfigurerAdapter"
        notes: "使用继承方式配置"
      boot_3_0:
        version: "6.0.x"
        config: "SecurityFilterChain Bean"
        notes: "WebSecurityConfigurerAdapter已废弃"
      boot_3_2:
        version: "6.2.x"
        config: "SecurityFilterChain Bean"
        notes: "推荐组件式配置"
    key_changes:
      - "WebSecurityConfigurerAdapter废弃"
      - "方法安全注解变更"
      - "授权规则语法变更"
      
  oauth2:
    compatibility:
      boot_2_7: { spring_security_oauth2: "2.5.x", notes: "已停止维护" }
      boot_3_0: { spring_security_oauth2: "6.0.x", notes: "整合到Spring Security" }
      boot_3_2: { spring_security_oauth2: "6.2.x", notes: "" }
    notes: "Spring Security OAuth2已废弃，建议迁移到Spring Authorization Server"
    
  jwt:
    starter: "spring-boot-starter-oauth2-resource-server"
    compatibility:
      boot_2_7: { nimbus_jwt: "8.x/9.x" }
      boot_3_0: { nimbus_jwt: "9.x/10.x" }
      boot_3_2: { nimbus_jwt: "10.x" }
```

#### 4.4 分布式组件兼容性

```yaml
distributed_compatibility:
  
  service_discovery:
    
    eureka:
      starter: "spring-cloud-starter-netflix-eureka-client"
      compatibility:
        spring_cloud_2021: { boot: "2.7.x" }
        spring_cloud_2022: { boot: "3.0.x/3.1.x" }
        spring_cloud_2023: { boot: "3.2.x/3.3.x" }
      
    nacos:
      starter: "spring-cloud-starter-alibaba-nacos-discovery"
      compatibility:
        spring_cloud_2021: { boot: "2.7.x", nacos: "2.2.x" }
        spring_cloud_2022: { boot: "3.0.x", nacos: "2.2.x" }
        spring_cloud_2023: { boot: "3.2.x", nacos: "2.3.x" }
      notes: "Nacos版本需要与Spring Cloud Alibaba版本匹配"
      
    consul:
      starter: "spring-cloud-starter-consul-discovery"
      compatibility:
        spring_cloud_2021: { boot: "2.7.x" }
        spring_cloud_2022: { boot: "3.0.x/3.1.x" }
        spring_cloud_2023: { boot: "3.2.x" }
        
  config_center:
    
    spring_cloud_config:
      compatibility:
        spring_cloud_2021: { boot: "2.7.x" }
        spring_cloud_2023: { boot: "3.2.x" }
        
    nacos_config:
      starter: "spring-cloud-starter-alibaba-nacos-config"
      compatibility: "同nacos-discovery"
      
  gateway:
    
    spring_cloud_gateway:
      compatibility:
        spring_cloud_2021: { boot: "2.7.x", java: "8+" }
        spring_cloud_2022: { boot: "3.0.x", java: "17+" }
        spring_cloud_2023: { boot: "3.2.x", java: "17+" }
      notes: "Spring Cloud Gateway 4.x需要Spring Cloud 2023.x"
      
    zuul:
      status: "已废弃"
      recommendation: "迁移到Spring Cloud Gateway"
      
  circuit_breaker:
    
    resilience4j:
      starter: "spring-cloud-starter-circuitbreaker-resilience4j"
      compatibility:
        spring_cloud_2021: { boot: "2.7.x" }
        spring_cloud_2023: { boot: "3.2.x" }
        
    hystrix:
      status: "已废弃"
      recommendation: "迁移到Resilience4j"
      
  distributed_transaction:
    
    seata:
      starter: "seata-spring-boot-starter"
      compatibility:
        boot_2_7: { seata: "1.6.x/1.7.x" }
        boot_3_0: { seata: "2.0.x" }
        boot_3_2: { seata: "2.0.x" }
      notes: "Seata 2.x支持Spring Boot 3.x"
```

#### 4.5 视图与模板兼容性

```yaml
view_compatibility:
  
  template_engines:
    
    thymeleaf:
      starter: "spring-boot-starter-thymeleaf"
      compatibility:
        boot_2_7: { version: "3.0.x" }
        boot_3_0: { version: "3.1.x" }
        boot_3_2: { version: "3.1.x" }
      notes: "Thymeleaf 3.x兼容性较好"
      
    freemarker:
      starter: "spring-boot-starter-freemarker"
      compatibility:
        boot_2_7: { version: "2.3.x" }
        boot_3_0: { version: "2.3.x" }
        boot_3_2: { version: "2.3.x" }
      
    jsp:
      compatibility:
        boot_2_7: "支持"
        boot_3_0: "不支持"
        boot_3_2: "不支持"
      migration_path: "JSP → Thymeleaf/JSP(需要war包部署)"
      
  rest_api:
    jackson:
      compatibility:
        boot_2_7: { version: "2.13.x" }
        boot_3_0: { version: "2.14.x" }
        boot_3_2: { version: "2.15.x" }
```

#### 4.6 Web服务与API兼容性

```yaml
web_service_compatibility:
  
  cxf:
    current_version: "2.6.2"
    artifact: "org.apache.cxf:cxf-core"
    release_history:
      2_6: { release: "2012-10", eol: "2014", java: "6+", notes: "非常旧的版本" }
      2_7: { release: "2013-10", eol: "2015", java: "6+", notes: "最后的2.x版本" }
      3_0: { release: "2014-12", eol: "2017", java: "7+", notes: "重大更新" }
      3_1: { release: "2016-03", eol: "2020", java: "8+" }
      3_4: { release: "2020-11", eol: "2023", java: "8+" }
      3_6: { release: "2023-03", eol: null, java: "8+", notes: "当前维护版本" }
      4_0: { release: "2023-09", eol: null, java: "11+", notes: "Jakarta EE 9支持" }
      4_1: { release: "2024-04", eol: null, java: "11+" }
      4_2: { release: "2026-02", eol: null, java: "17+", notes: "Jakarta EE 11支持" }
    compatibility:
      boot_2_7: { version: "3.4.x/3.6.x", notes: "需要jaxws-api依赖" }
      boot_3_0: { version: "4.0.x", notes: "需要jakarta.jws-api" }
      boot_3_2: { version: "4.1.x", notes: "" }
      boot_3_3: { version: "4.2.x", notes: "推荐" }
    upgrade_path: "2.6.x → 3.4.x → 3.6.x → 4.0.x → 4.1.x → 4.2.x"
    key_changes:
      - "2.x→3.x: 新的传输层，性能改进"
      - "3.4→3.6: Spring 5.x支持"
      - "3.6→4.0: javax.jws → jakarta.jws"
      - "4.0→4.2: Jakarta EE 11支持"
    migration_notes: |
      # CXF迁移要点
      1. JAX-WS注解包名变更: javax.jws → jakarta.jws
      2. JAX-RS注解包名变更: javax.ws.rs → jakarta.ws.rs
      3. Spring XML配置需要调整
      4. 客户端生成代码需要重新生成
    risk_level: "high"
    
  jax_ws:
    notes: "如果使用原生JAX-WS，需要关注javax.xml.ws → jakarta.xml.ws变更"
    
  jax_rs:
    notes: "如果使用原生JAX-RS，需要关注javax.ws.rs → jakarta.ws.rs变更"
```

#### 4.7 工具类兼容性

```yaml
utility_compatibility:
  
  poi:
    current_version: "3.17"
    artifact: "org.apache.poi:poi"
    release_history:
      3_17: { release: "2017-09", eol: "2018", java: "6+", notes: "最后的3.x版本" }
      4_0: { release: "2018-08", eol: "2019", java: "8+", notes: "重大API变更" }
      4_1: { release: "2019-04", eol: "2020", java: "8+" }
      5_0: { release: "2021-01", eol: "2022", java: "8+", notes: "性能改进" }
      5_2: { release: "2022-01", eol: "2023", java: "8+", notes: "" }
      5_4: { release: "2025-01", eol: null, java: "8+", notes: "" }
      5_5: { release: "2025-11", eol: null, java: "8+", notes: "当前稳定版" }
    compatibility:
      boot_2_7: { version: "5.2.x" }
      boot_3_0: { version: "5.2.x" }
      boot_3_2: { version: "5.2.x/5.4.x" }
      boot_3_3: { version: "5.5.x", notes: "推荐" }
    upgrade_path: "3.17 → 4.0.x → 4.1.x → 5.0.x → 5.2.x → 5.5.x"
    key_changes:
      - "3.17→4.0: API重大变更，废弃大量旧API"
      - "4.0→4.1: Cell.CELL_TYPE_* 变为CellType枚举"
      - "4.1→5.0: 包名重构，性能改进"
      - "5.0→5.2: 稳定性改进"
    api_changes: |
      # POI 3.x到5.x主要API变更
      1. HSSFCellStyle/XSSFCellStyle → CellStyle
      2. HSSFFont/XSSFFont → Font
      3. HSSFColor → IndexedColors
      4. Cell.CELL_TYPE_* → CellType 枚举
      5. Row.createCell(int, int) → Row.createCell(int, CellType)
      6. Region → CellRangeAddress
    risk_level: "medium"
    
  json_lib:
    current_version: "2.4"
    artifact: "net.sf.json-lib:json-lib"
    status: "已停止维护"
    release_history:
      2_4: { release: "2010-12", eol: true, java: "5+", notes: "最后版本" }
    compatibility:
      note: "已停止维护，建议迁移到Jackson或Gson"
    migration_recommendation: |
      # JSON-lib迁移建议
      1. 优先迁移到Jackson (Spring Boot默认)
      2. 如需轻量级方案，可选择Gson
      3. JSON-lib依赖commons-collections旧版本，存在安全漏洞
      
      迁移代码示例:
      // 旧代码
      import net.sf.json.JSONObject;
      JSONObject jsonObject = JSONObject.fromObject(str);
      
      // 新代码 (Jackson)
      import com.fasterxml.jackson.databind.ObjectMapper;
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(str);
    risk_level: "medium"
    
  protostuff:
    current_version: "1.4.3"
    artifact: "io.protostuff:protostuff-core"
    release_history:
      1_4: { release: "2016-05", java: "6+", notes: "较旧版本" }
      1_5: { release: "2018-02", java: "6+" }
      1_6: { release: "2019-10", java: "8+" }
      1_7: { release: "2021-04", java: "8+" }
      1_8: { release: "2022-03", java: "8+", notes: "当前最新版本" }
    status: "维护模式，更新不活跃"
    compatibility:
      boot_2_7: { version: "1.7.x/1.8.x" }
      boot_3_0: { version: "1.8.x" }
      boot_3_2: { version: "1.8.x" }
    notes: "Protostuff是纯Java库，与Spring Boot版本无直接依赖"
    key_changes:
      - "1.4→1.5: 性能改进"
      - "1.7→1.8: 新增配置选项"
    risk_level: "low"
    
  dorado:
    current_version: "7.4.0"
    notes: |
      Dorado是一个轻量级的Java Web框架，主要在中国使用。
      需要确认具体使用场景：
      - 如果是MVC框架：需要评估与Spring Boot的兼容性
      - 如果是工具库：通常兼容性较好
    compatibility:
      boot_2_7: { notes: "需要测试验证" }
      boot_3_0: { notes: "需要测试验证" }
    recommendation: "建议确认Dorado的具体用途，评估是否可以移除或替换"
    risk_level: "medium"
```

#### 4.8 测试框架兼容性

```yaml
test_compatibility:
  
  junit:
    compatibility:
      boot_2_7: { junit4: "支持", junit5: "4.13.x", notes: "推荐JUnit 5" }
      boot_3_0: { junit4: "支持", junit5: "5.9.x", notes: "" }
      boot_3_2: { junit4: "支持", junit5: "5.10.x", notes: "" }
    key_changes:
      - "@RunWith → @ExtendWith"
      - "@SpringBootTest兼容"
      
  mockito:
    compatibility:
      boot_2_7: { version: "4.5.x/4.6.x" }
      boot_3_0: { version: "5.x" }
      boot_3_2: { version: "5.x" }
      
  spring_test:
    compatibility:
      boot_2_7: { spring_test: "5.3.x" }
      boot_3_0: { spring_test: "6.0.x" }
      boot_3_2: { spring_test: "6.1.x" }
```

#### 4.9 开发工具兼容性

```yaml
dev_tools_compatibility:
  
  lombok:
    compatibility:
      boot_2_7: { version: "1.18.x" }
      boot_3_0: { version: "1.18.x", notes: "需要与Java版本匹配" }
      boot_3_2: { version: "1.18.x" }
    notes: "Lombok与Spring Boot版本无直接依赖，主要关注Java版本"
    key_issues:
      - "Java 17+需要更新的Lombok版本"
      - "与IDE插件版本匹配"
      
  mapstruct:
    compatibility:
      boot_2_7: { version: "1.5.x" }
      boot_3_0: { version: "1.5.x" }
      boot_3_2: { version: "1.6.x" }
    notes: "纯编译时工具，与Spring Boot版本无直接依赖"
    
  swagger_springfox:
    status: "已停止维护"
    recommendation: "迁移到springdoc-openapi"
    migration_guide: |
      # Springfox迁移到springdoc
      1. 移除springfox依赖
      2. 添加springdoc-openapi-ui依赖
      3. 将@ApiModel改为@Schema
      4. 将@ApiModelProperty改为@Schema
      5. 访问路径从/swagger-ui.html变更为/swagger-ui.html或/swagger-ui/index.html
      
  springdoc_openapi:
    compatibility:
      boot_2_7: { version: "1.x (1.6.x/1.7.x)", notes: "使用springdoc-openapi-ui" }
      boot_3_0: { version: "2.x (2.0.x/2.1.x)", notes: "使用springdoc-openapi-starter-webmvc-ui" }
      boot_3_2: { version: "2.x (2.3.x)", notes: "" }
    notes: "推荐使用springdoc-openapi替代springfox"
    
  knife4j:
    compatibility:
      boot_2_7: { version: "3.x/4.x" }
      boot_3_0: { version: "4.x", notes: "需要springdoc 2.x" }
      boot_3_2: { version: "4.x" }
    notes: "国产API文档增强工具，基于springdoc"
    
  actuator:
    compatibility:
      boot_2_7: { version: "2.7.x" }
      boot_3_0: { version: "3.0.x" }
      boot_3_2: { version: "3.2.x" }
    notes: "端点路径和配置可能有变化"
    
  devtools:
    compatibility:
      boot_2_7: { version: "2.7.x" }
      boot_3_0: { version: "3.0.x" }
      boot_3_2: { version: "3.2.x" }
    notes: "开发工具，版本跟随Boot版本"
```

#### 4.10 常用第三方starter兼容性

```yaml
third_party_starter_compatibility:
  
  pagehelper:
    artifact: "com.github.pagehelper:pagehelper-spring-boot-starter"
    compatibility:
      boot_2_7: { version: "1.4.x" }
      boot_3_0: { version: "2.0.x" }
      boot_3_2: { version: "2.0.x" }
    notes: "MyBatis分页插件"
    
  hutool:
    artifact: "cn.hutool:hutool-all"
    compatibility:
      boot_2_7: { version: "5.x" }
      boot_3_0: { version: "5.x" }
      boot_3_2: { version: "5.x" }
    notes: "纯工具库，与Spring Boot版本无直接依赖"
    
  easyexcel:
    artifact: "com.alibaba:easyexcel"
    compatibility:
      boot_2_7: { version: "3.x" }
      boot_3_0: { version: "3.x" }
      boot_3_2: { version: "3.x" }
    notes: "阿里巴巴Excel处理库，内部封装了POI"
    
  redisson:
    artifact: "org.redisson:redisson-spring-boot-starter"
    compatibility:
      boot_2_7: { version: "3.16.x/3.17.x" }
      boot_3_0: { version: "3.20.x" }
      boot_3_2: { version: "3.25.x" }
    notes: "Redis分布式锁和缓存"
    
  xxl_job:
    artifact: "com.xuxueli:xxl-job-core"
    compatibility:
      boot_2_7: { version: "2.3.x/2.4.x" }
      boot_3_0: { version: "2.4.x" }
      boot_3_2: { version: "2.4.x" }
    notes: "分布式任务调度"
    
  minio:
    artifact: "io.minio:minio"
    compatibility:
      boot_2_7: { version: "8.x" }
      boot_3_0: { version: "8.x" }
      boot_3_2: { version: "8.x" }
    notes: "对象存储，纯Java SDK"
    
  elasticsearch_rest:
    compatibility:
      boot_2_7: { version: "7.17.x", notes: "High Level REST Client" }
      boot_3_0: { version: "8.x", notes: "Elasticsearch Java Client" }
      boot_3_2: { version: "8.x" }
    notes: "ES 7.x到8.x客户端完全重写"
    
  mongodb:
    compatibility:
      boot_2_7: { version: "4.x" }
      boot_3_0: { version: "4.x/5.x" }
      boot_3_2: { version: "5.x" }
    notes: "Spring Data MongoDB版本跟随Boot"
    
  druid:
    artifact: "com.alibaba:druid"
    current_version: "1.2.x"
    release_history:
      1_0: { release: "2017", java: "7+" }
      1_1: { release: "2018", java: "8+" }
      1_2: { release: "2021", java: "8+", notes: "当前稳定版系列" }
    starters:
      boot_2: "druid-spring-boot-starter"
      boot_3: "druid-spring-boot-3-starter"
      boot_4: "druid-spring-boot-4-starter"
    compatibility:
      boot_2_7: { starter: "druid-spring-boot-starter", version: "1.2.x" }
      boot_3_0: { starter: "druid-spring-boot-3-starter", version: "1.2.20+" }
      boot_3_2: { starter: "druid-spring-boot-3-starter", version: "1.2.23+" }
      boot_4_0: { starter: "druid-spring-boot-4-starter", version: "1.2.28" }
    notes: "注意：Boot 2/3/4使用不同的starter"
    
  fastjson:
    artifact_old: "com.alibaba:fastjson"
    artifact_new: "com.alibaba.fastjson2:fastjson2"
    release_history:
      fastjson_1: { version: "1.2.83", status: "已停止维护", notes: "有安全漏洞" }
      fastjson2: { version: "2.0.x", status: "活跃维护", notes: "推荐使用" }
    compatibility:
      boot_2_7: { fastjson2: "2.0.x", extension: "fastjson2-extension-spring5" }
      boot_3_0: { fastjson2: "2.0.x", extension: "fastjson2-extension-spring6" }
      boot_3_2: { fastjson2: "2.0.x", extension: "fastjson2-extension-spring6" }
    migration_guide: |
      # Fastjson 1.x迁移到Fastjson2
      1. 替换依赖: com.alibaba:fastjson → com.alibaba.fastjson2:fastjson2
      2. 添加兼容包: fastjson2-compatible (可选)
      3. 更新import: com.alibaba.fastjson → com.alibaba.fastjson2
      4. 注意: 部分API有变化，需要调整
    risk_level: "medium"
    
  commons_lang:
    artifact: "org.apache.commons:commons-lang3"
    compatibility:
      note: "纯工具库，与Spring Boot版本无直接依赖"
    versions:
      - "3.12.0: 2021"
      - "3.14.0: 2023"
      - "3.17.0: 2024"
      
  commons_io:
    artifact: "commons-io:commons-io"
    compatibility:
      note: "纯工具库，与Spring Boot版本无直接依赖"
    versions:
      - "2.15.1: 2024"
      
  guava:
    artifact: "com.google.guava:guava"
    compatibility:
      note: "纯工具库，与Spring Boot版本无直接依赖"
    versions:
      - "32.x: 2023"
      - "33.x: 2024"
```

#### 4.11 Spring Cloud组件兼容性

```yaml
spring_cloud_compatibility:
  
  version_matrix:
    
    spring_cloud_2020:
      boot_versions: ["2.4.x", "2.5.x"]
      java: "8+"
      components: "Hoxton系列"
      
    spring_cloud_2021:
      boot_versions: ["2.6.x", "2.7.x"]
      java: "8+"
      components:
        eureka: "3.1.x"
        gateway: "3.1.x"
        openfeign: "3.1.x"
        circuitbreaker: "3.0.x"
        
    spring_cloud_2022:
      boot_versions: ["3.0.x", "3.1.x"]
      java: "17+"
      components:
        eureka: "4.0.x"
        gateway: "4.0.x"
        openfeign: "4.0.x"
        circuitbreaker: "3.0.x"
        
    spring_cloud_2023:
      boot_versions: ["3.2.x", "3.3.x"]
      java: "17+"
      components:
        eureka: "4.1.x"
        gateway: "4.1.x"
        openfeign: "4.1.x"
        circuitbreaker: "3.1.x"
        
    spring_cloud_2024:
      boot_versions: ["3.4.x"]
      java: "17+"
      components:
        eureka: "4.2.x"
        gateway: "4.2.x"
        openfeign: "4.2.x"
        
    spring_cloud_2025:
      boot_versions: ["3.5.x"]
      java: "17+"
      components:
        eureka: "4.3.x"
        gateway: "4.3.x"
        openfeign: "4.3.x"
        
  openfeign:
    artifact: "spring-cloud-starter-openfeign"
    release_history:
      2_2: { boot: "2.3.x/2.4.x", notes: "旧版本" }
      3_0: { boot: "2.6.x", notes: "" }
      3_1: { boot: "2.7.x", notes: "" }
      4_0: { boot: "3.0.x", notes: "Jakarta支持" }
      4_1: { boot: "3.2.x", notes: "" }
      4_2: { boot: "3.4.x", notes: "" }
      4_3: { boot: "3.5.x", notes: "最新" }
    notes: "版本与Spring Cloud版本绑定"
    
  gateway:
    artifact: "spring-cloud-starter-gateway"
    release_history:
      3_0: { boot: "2.6.x", notes: "" }
      3_1: { boot: "2.7.x", notes: "" }
      4_0: { boot: "3.0.x", notes: "WebFlux基础" }
      4_1: { boot: "3.2.x", notes: "" }
      4_2: { boot: "3.4.x", notes: "" }
    notes: "基于WebFlux，不兼容Spring MVC"
    
  circuitbreaker:
    notes: "Spring Cloud Circuitbreaker替代Hystrix"
    implementations:
      - "Resilience4j (推荐)"
      - "Sentinel (阿里巴巴)"
```

#### 4.12 阿里巴巴Spring Cloud Alibaba兼容性

```yaml
spring_cloud_alibaba_compatibility:
  
  version_matrix:
    
    2_2_x: { boot: "2.2.x", cloud: "Hoxton", java: "8+" }
    2020_x: { boot: "2.4.x/2.5.x", cloud: "2020.0.x", java: "8+" }
    2021_x: { boot: "2.6.x/2.7.x", cloud: "2021.0.x", java: "8+" }
    2022_x: { boot: "3.0.x", cloud: "2022.0.x", java: "17+" }
    2023_x: { boot: "3.2.x", cloud: "2023.0.x", java: "17+" }
    2025_x: { boot: "3.5.x", cloud: "2025.0.x", java: "17+" }
    
  components:
    
    nacos:
      description: "服务发现和配置中心"
      compatibility:
        boot_2_7: { client: "2.2.x", server: "2.x" }
        boot_3_0: { client: "2.3.x", server: "2.x" }
        boot_3_2: { client: "2.4.x", server: "2.x" }
        boot_3_5: { client: "3.0.x", server: "2.x/3.x" }
        
    sentinel:
      description: "流量控制和熔断降级"
      compatibility:
        boot_2_7: { version: "1.8.x" }
        boot_3_0: { version: "1.8.x" }
        boot_3_2: { version: "1.8.x" }
        
    seata:
      description: "分布式事务"
      compatibility:
        boot_2_7: { version: "1.6.x/1.7.x" }
        boot_3_0: { version: "2.0.x" }
        boot_3_2: { version: "2.0.x" }
        
    rocketmq:
      description: "消息队列"
      compatibility:
        boot_2_7: { starter: "rocketmq-spring-boot-starter", version: "2.2.x" }
        boot_3_0: { starter: "rocketmq-spring-boot-starter", version: "2.3.x" }
        boot_3_2: { starter: "rocketmq-spring-boot-starter", version: "2.3.x" }
```

#### 4.13 日志框架兼容性

```yaml
logging_compatibility:
  
  logback:
    notes: "Spring Boot默认日志框架"
    compatibility:
      boot_2_7: { version: "1.2.x" }
      boot_3_0: { version: "1.4.x" }
      boot_3_2: { version: "1.4.x" }
    notes: "版本跟随Boot自动管理"
    
  log4j2:
    notes: "需要排除默认logback"
    compatibility:
      boot_2_7: { version: "2.17.x" }
      boot_3_0: { version: "2.20.x" }
      boot_3_2: { version: "2.21.x" }
    setup: |
      <dependency>
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-log4j2</artifactId>
      </dependency>
      
  slf4j:
    notes: "日志门面，版本跟随Boot"
    compatibility:
      boot_2_7: { version: "1.7.x" }
      boot_3_0: { version: "2.0.x" }
      boot_3_2: { version: "2.0.x" }
```

#### 4.14 HTTP客户端兼容性

```yaml
http_client_compatibility:
  
  apache_httpclient:
    artifact: "org.apache.httpcomponents:httpclient"
    compatibility:
      boot_2_7: { version: "4.5.x", notes: "HttpClient 4.x" }
      boot_3_0: { version: "5.3.x", notes: "HttpClient 5.x" }
      boot_3_2: { version: "5.3.x" }
    notes: "Spring Boot 3.x默认使用HttpClient 5"
    
  okhttp:
    artifact: "com.squareup.okhttp3:okhttp"
    compatibility:
      note: "纯HTTP客户端库，与Boot版本无直接依赖"
    versions:
      - "4.x: 2023+"
      
  resttemplate:
    notes: "Spring Web组件，随Boot版本升级"
    replacement: "推荐迁移到WebClient或HTTP Interface"
    
  webclient:
    notes: "Spring WebFlux响应式客户端"
    compatibility:
      boot_2_7: { version: "5.3.x" }
      boot_3_0: { version: "6.0.x" }
      boot_3_2: { version: "6.1.x" }
      
  http_interface:
    notes: "Spring 6新增，推荐用于同步HTTP调用"
    available_since: "Spring Boot 3.0"
```

#### 4.15 任务调度兼容性

```yaml
scheduling_compatibility:
  
  quartz:
    artifact: "org.quartz-scheduler:quartz"
    compatibility:
      boot_2_7: { version: "2.3.x" }
      boot_3_0: { version: "2.3.x" }
      boot_3_2: { version: "2.3.x" }
    notes: "纯Java调度库，兼容性好"
    
  elastic_job:
    artifact: "org.apache.shardingsphere.elasticjob"
    compatibility:
      boot_2_7: { version: "3.0.x" }
      boot_3_0: { version: "3.0.x" }
    notes: "ShardingSphere ElasticJob"
    
  xxl_job:
    artifact: "com.xuxueli:xxl-job-core"
    compatibility:
      boot_2_7: { version: "2.4.x" }
      boot_3_0: { version: "2.4.x" }
    notes: "分布式任务调度平台"
    
  schedulerx:
    notes: "阿里云SchedulerX，需要SDK支持"
    compatibility:
      spring_cloud_alibaba_2025: { version: "1.13.x" }
```
