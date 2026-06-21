# 附录

## 查询工具使用

### 1. 查询Spring官网

```
使用webfetch工具查询:
- https://spring.io/projects/spring-boot#support (版本支持信息)
- https://docs.spring.io/spring-boot/docs/current/reference/html/ (官方文档)
- https://github.com/spring-projects/spring-boot/wiki (迁移指南)
- https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-2.7-Release-Notes
- https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Release-Notes
```

### 2. 查询Maven仓库

```
使用websearch工具搜索:
- "{artifact} spring boot {version} compatibility"
- "{artifact} {version} maven"
- "mvnrepository {artifact}"
- "{dependency} version compatibility matrix"
```

### 3. 查询常见问题

```
使用websearch工具搜索:
- "{error_message} spring boot {version}"
- "{component} migration spring boot"
- "spring boot upgrade {component} issues"
- "{error} spring boot 3.x solution"
```

### 4. 查询迁移指南

```
使用websearch工具搜索:
- "spring boot migration guide {version}"
- "spring boot {from} to {to} migration"
- "openrewrite {component} migration recipe"
```

---

## 升级前检查清单

```yaml
pre_upgrade_checklist:
  
  environment:
    - "确认Java版本满足目标Boot版本要求"
    - "确认Maven/Gradle版本兼容"
    - "确认IDE支持目标Java版本"
    - "准备独立的测试环境"
    
  code:
    - "备份当前代码（创建分支或tag）"
    - "确认所有代码已提交"
    - "确认测试用例可执行"
    - "确认CI/CD配置可回滚"
    
  dependencies:
    - "列出所有直接依赖"
    - "列出所有传递依赖"
    - "确认内部组件兼容性"
    - "确认商业组件授权"
    
  configuration:
    - "备份所有配置文件"
    - "记录当前环境变量"
    - "记录当前启动参数"
    - "确认外部配置中心配置"
    
  documentation:
    - "记录当前架构图"
    - "记录关键业务流程"
    - "准备迁移文档模板"
    - "通知相关团队成员"
```

---

## 升级后验证清单

```yaml
post_upgrade_checklist:
  
  basic:
    - "应用能正常启动"
    - "所有Profile能正常加载"
    - "配置文件能正确读取"
    - "日志输出正常"
    
  functionality:
    - "所有API接口正常响应"
    - "数据库CRUD操作正常"
    - "事务管理正常"
    - "缓存读写正常"
    - "消息收发正常"
    - "定时任务正常"
    - "安全认证正常"
    
  integration:
    - "与外部系统集成正常"
    - "与中间件连接正常"
    - "与配置中心同步正常"
    - "与注册中心通信正常"
    
  performance:
    - "响应时间在可接受范围"
    - "CPU使用率正常"
    - "内存使用正常"
    - "连接池使用正常"
    
  monitoring:
    - "Actuator端点可访问"
    - "健康检查正常"
    - "监控指标正常采集"
    - "告警规则正常触发"
```

---

### 专有框架升级验证清单

```yaml
proprietary_framework_checklist:
  
  servlet:
    - "所有专有框架Servlet通过ServletRegistrationBean注册"
    - "Servlet的setName()与web.xml的<servlet-name>一致"
    - "URL映射模式完整覆盖（含所有*.d、*.do等）"
    - "loadOnStartup顺序保留"
    
  filter:
    - "所有Filter通过FilterRegistrationBean注册"
    - "setOrder()值保持web.xml声明顺序"
    - "确认DelegatingFilterProxy是框架版本（非Spring同名类）"
    
  context:
    - "框架所有context.xml在@ImportResource中按依赖序声明"
    - "区分ROOT Context（@ImportResource）和Servlet子Context（框架机制加载）"
    - "子Context配置正确写入框架配置存储层"
    - "分隔符与框架内部一致（;而非,）"
    
  global_state:
    - "ServletContextInitializer正确初始化框架全局状态"
    - "初始化在Bean实例化之前执行"
    - "框架静态方法（如Context.getCurrent()）不返回null"
    
  compile:
    - "mvn compile通过"
    - "mvn dependency:tree无版本冲突"
    
  startup:
    - "应用启动无异常"
    - "无BeanDefinitionOverrideException"
    - "无NoSuchBeanDefinitionException"
    - "无BeanCreationException"
    
  functional:
    - "框架URL模式请求正常（不返回404）"
    - "框架页面渲染正常"
    - "框架Filter链正常执行"
    - "WAR部署方式不冲突（外部Tomcat + web.xml共存）"
```

```yaml
rollback_strategy:
  
  rollback_triggers:
    - "应用无法启动"
    - "核心业务功能异常"
    - "性能严重下降"
    - "数据一致性问题"
    
  rollback_steps:
    
    immediate:
      - "停止新版本应用"
      - "恢复旧版本应用"
      - "验证旧版本正常"
      
    code_rollback:
      - "git checkout {previous_tag}"
      - "重新构建部署"
      
    config_rollback:
      - "恢复旧配置文件"
      - "恢复旧环境变量"
      - "恢复旧启动参数"
      
    data_rollback:
      - "评估是否需要数据回滚"
      - "执行数据库备份恢复"
      - "验证数据一致性"
      
  communication:
    - "通知运维团队"
    - "通知业务团队"
    - "记录回滚原因"
    - "安排问题排查会议"
```

---

## 常见陷阱与解决方案

```yaml
common_pitfalls:
  
  - pitfall: "版本冲突"
    description: "手动指定的版本与starter管理的版本冲突"
    solution: |
      使用dependencyManagement统一管理版本
      或在properties中覆盖版本
      
  - pitfall: "配置覆盖"
    description: "Spring Boot自动配置被意外覆盖"
    solution: |
      使用@ConditionalOnMissingBean理解自动配置
      使用debug模式查看自动配置报告
      
  - pitfall: "包扫描"
    description: "启动类位置导致组件扫描不到"
    solution: |
      将启动类放在根包下
      或使用@ComponentScan指定扫描路径
      
  - pitfall: "循环依赖"
    description: "新版本对循环依赖支持变化"
    solution: |
      配置spring.main.allow-circular-references=true
      或重构代码消除循环依赖
      
  - pitfall: "废弃API"
    description: "使用了已废弃的API"
    solution: |
      查阅Release Notes中的废弃API列表
      使用IDE的Deprecation检查功能
      
  - pitfall: "默认值变更"
    description: "配置默认值在新版本中变更"
    solution: |
      显式配置关键属性
      查阅官方文档的默认值变更列表
      
  - pitfall: "传递依赖"
    description: "传递依赖引入了冲突的版本"
    solution: |
      使用mvn dependency:tree分析依赖树
      使用exclusions排除冲突依赖

  - pitfall: "专有框架Servlet未注册（嵌入式Tomcat）"
    description: "Spring Boot嵌入式Tomcat忽略web.xml，专有框架Servlet未注册"
    solution: |
      使用ServletRegistrationBean编程式注册
      必须setName()与web.xml的<servlet-name>一致以支持WAR共存

  - pitfall: "专有框架Context依赖链不完整"
    description: "框架JAR内的多个context.xml有依赖顺序，漏加载导致Bean缺失"
    solution: |
      解压框架JAR，分析所有context.xml的依赖关系
      在@ImportResource中按依赖顺序声明

  - pitfall: "专有框架使用自定义配置存储而非ServletContext"
    description: "框架不从ServletContext读取配置，从自定义存储层（如Configure Store）读取"
    solution: |
      反编译框架Servlet确认配置读取来源
      操作框架的配置存储层而非ServletContext属性

  - pitfall: "框架全局状态未初始化导致静态NPE"
    description: "框架的静态方法依赖初始化阶段设置的全局状态（如failSafeContext）"
    solution: |
      使用ServletContextInitializer在Tomcat创建后初始化框架上下文
      确保初始化在Bean实例化前执行

  - pitfall: "Woodstox/StAX多版本冲突"
    description: "CXF旧版woodstox-core-asl + Solr旧版wstx-asl + Jackson新版woodstox-core 三版本冲突"
    solution: |
      mvn dependency:tree -Dincludes="*woodstox*,*stax2*" 分析冲突
      从cxf-core排除woodstox-core-asl，从solr-solrj排除wstx-asl

  - pitfall: "EhCache新旧版本类路径冲突"
    description: "ehcache-core:2.6.9和ehcache:2.10.9.2并存导致NoSuchMethodError"
    solution: |
      移除旧版ehcache-core:2.6.9显式依赖，仅保留hibernate-ehcache传递的版本

  - pitfall: "Maven资源配置过窄"
    description: "<resources>的<include>只包含特定类型文件，application.properties等未编译"
    solution: |
      将<include>改为<include>**/*</include>覆盖所有资源文件

  - pitfall: "PropertyPlaceholderConfigurer未注册为Bean"
    description: "XML中注释了旧<bean>定义但无@Bean方法替代"
    solution: |
      添加@Bean static方法返回PropertySourcesPlaceholderConfigurer子类
      static必需——BFPP在容器早期阶段创建

  - pitfall: "ignoreUnresolvablePlaceholders默认false"
    description: "自定义Configurer与框架的Configurer共存时，遇到框架占位符报错"
    solution: |
      configurer.setIgnoreUnresolvablePlaceholders(true)
      各自负责自己的占位符，互不干扰

  - pitfall: "Spring Data Redis 2.x RedisCacheConfiguration不可变"
    description: "RedisCacheConfiguration所有字段private final，无setter，XML无法注入"
    solution: |
      创建FactoryBean包装类，通过builder模式方法构造配置
      XML引用FactoryBean而非直接使用RedisCacheConfiguration

  - pitfall: "CacheManager.getCacheNames()返回不可修改集合"
    description: "Spring 5.3.x返回Collections.unmodifiableSet()，直接retainAll抛异常"
    solution: |
      先复制到new LinkedHashSet<>()后再调用retainAll()
```

---

## 附录：版本对应关系速查表

```yaml
quick_reference:
  
  spring_boot_to_spring_framework:
    boot_2_7: "Spring 5.3.x"
    boot_3_0: "Spring 6.0.x"
    boot_3_1: "Spring 6.1.x"
    boot_3_2: "Spring 6.1.x"
    boot_3_3: "Spring 6.2.x"
    
  spring_boot_to_java:
    boot_2_7: "Java 8+"
    boot_3_0: "Java 17+"
    boot_3_1: "Java 17+"
    boot_3_2: "Java 17+"
    boot_3_3: "Java 17+"
    
  spring_boot_to_gradle:
    boot_2_7: "Gradle 7.5+"
    boot_3_0: "Gradle 7.5+"
    boot_3_2: "Gradle 7.5+"
    boot_3_3: "Gradle 8.x"
    
  spring_boot_to_maven:
    boot_2_7: "Maven 3.6+"
    boot_3_0: "Maven 3.6+"
    boot_3_2: "Maven 3.8+"
    boot_3_3: "Maven 3.9+"
```
