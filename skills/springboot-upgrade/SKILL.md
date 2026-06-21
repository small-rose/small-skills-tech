---
name: springboot-upgrade
description: Spring Boot升级方案生成器。支持传统Spring MVC升级到Spring Boot，以及Spring Boot低版本升级到高版本。分析组件兼容性、评估风险、生成详细改造方案，目标是尽可能减少改动同时保证升级后正常运行。
tags:
  - "spring-boot"
  - "migration"
  - "compatibility"
  - "spring-mvc"
  - "configuration"
  - "maven"
author:
  name: "small-skills-tech"
  github: "small-skills-tech"
source: "https://github.com/small-skills-tech/small-skills-tech/tree/main/skills/springboot-upgrade"
triggers:
  - "springboot升级"
  - "spring boot升级"
  - "springboot版本升级"
  - "springmvc转springboot"
  - "springmvc迁移"
  - "springboot改造"
  - "升级springboot"
  - "版本兼容分析"
  - "spring组件兼容"
  - "升级方案"
  - "专有框架迁移"
  - "dorado迁移"
  - "传统web.xml迁移"
  - "springmvc配置文件迁移"
  - "springboot profile归并"
  - "配置体系迁移"
  - "redis缓存升级"
  - "ehcache冲突"
  - "缓存组件升级"
  - "密码解密"
  - "PropertyPlaceholder迁移"
---

# Spring Boot升级方案生成器

## 核心原则
- **最小改动原则**：尽可能保留现有代码和配置，只做必要修改
- **兼容性优先**：充分分析组件版本兼容性，避免引入冲突
- **渐进式升级**：分阶段实施，降低风险
- **配置兼容**：尽可能复用原有XML配置，通过适配层兼容

---

## 快速决策树

```yaml
quick_decision:
  # 第一步：判断当前状态
  current_state:
    
    - condition: "没有Spring，纯Servlet/JSP项目"
      action: "先迁移到Spring MVC，再考虑Spring Boot"
      skip_to: "传统Servlet迁移策略"
      
    - condition: "Spring MVC 3.x/4.x"
      action: "直接升级到Spring Boot 2.7.x"
      skip_to: "Spring MVC升级策略"
      note: "2.7是2.x最终版本，兼容性最好"
      
    - condition: "Spring MVC 5.x (非Boot)"
      action: "升级到Spring Boot 2.7.x，可选后续升级3.x"
      skip_to: "Spring MVC升级策略"
      
    - condition: "Spring Boot 1.x"
      action: "升级到Spring Boot 2.7.x"
      skip_to: "Boot版本升级策略"
      
    - condition: "Spring Boot 2.x"
      action: "评估Java版本决定"
      skip_to: "Boot版本升级策略"
      
    - condition: "Spring Boot 3.0/3.1"
      action: "升级到3.2.x或3.3.x"
      skip_to: "Boot增量升级策略"
      
  # 第二步：Java版本决策
  java_version_check:
    
    - condition: "Java 8"
      possible_targets: ["2.7.x"]
      blocked: ["3.x"]
      action: "保持Java 8只能选择2.7.x"
      
    - condition: "Java 11"
      possible_targets: ["2.7.x", "3.0.x (需升级Java)"]
      action: "推荐2.7.x，3.x需要先升级Java"
      
    - condition: "Java 17"
      possible_targets: ["2.7.x", "3.0.x", "3.1.x", "3.2.x", "3.3.x"]
      action: "推荐3.2.x或3.3.x"
      
    - condition: "Java 21"
      possible_targets: ["2.7.x", "3.x所有版本"]
      action: "推荐3.3.x"

  # 第三步：专有框架检测
  proprietary_framework:
    
    - condition: "使用Dorado、Vaadin、ZK、GWT等RIA框架"
      action: "必须执行专有框架迁移四步法"
      skip_to: "专有框架迁移"
      note: "需分析web.xml、框架JAR内context.xml依赖链、Servlet初始化逻辑"
      
    - condition: "使用公司内部封装框架（如fndsoft工作流引擎）"
      action: "检查循环依赖、PropertyPlaceholder冲突"
      skip_to: "配置文件迁移"
      
    - condition: "纯标准Spring技术栈"
      action: "按标准工作流执行"
```

---

## 工作流程

### 模块说明

本SKILL已拆分为多个模块，按需加载：

| 模块 | 文件 | 内容 |
|------|------|------|
| 步骤1-3 | [modules/01-analysis.md](modules/01-analysis.md) | 工程信息采集、升级类型判断、版本时间线 |
| 步骤4 | [modules/02-component-compat.md](modules/02-component-compat.md) | 组件兼容性深度分析（15类组件） |
| 步骤5-6 | [modules/03-risk-migration.md](modules/03-risk-migration.md) | 风险评估体系、自动化迁移工具 |
| 步骤7-8 | [modules/04-multi-module-cicd.md](modules/04-multi-module-cicd.md) | 多模块升级策略、CI/CD与部署 |
| 步骤9 | [modules/05-faq-debug.md](modules/05-faq-debug.md) | 常见错误案例库、调试技巧速查表 |
| 步骤10 | [modules/06-report.md](modules/06-report.md) | 升级报告模板、工作量评估 |
| **步骤11** | [modules/07-dorado-framework.md](modules/07-dorado-framework.md) | **★新增** 专有框架迁移四步法 |
| **步骤12** | [modules/08-config-migration.md](modules/08-config-migration.md) | **★新增** 配置体系迁移指南 |
| **步骤13** | [modules/09-data-migration.md](modules/09-data-migration.md) | **★新增** 数据层组件迁移指南 |
| 附录 | [appendix.md](appendix.md) | 检查清单、回滚策略、速查表 |

### 工作流程

```
1. 读取快速决策树 → 确定升级方向
2. 加载 modules/01-analysis.md → 工程信息采集与策略选择
3. 加载 modules/02-component-compat.md → 组件兼容性分析
4. 加载 modules/03-risk-migration.md → 风险评估与迁移工具
5. 加载 modules/04-multi-module-cicd.md → 多模块与CI/CD（如需要）
6. 加载 modules/05-faq-debug.md → 问题排查（遇到问题时）
7. 加载 modules/06-report.md → 生成升级报告
---
[专有框架检测分支]:
   8. 加载 modules/07-dorado-framework.md → 专有框架迁移四步法
---
[常见附加分支]:
   8. 加载 modules/08-config-migration.md → 配置体系迁移（如需要）
   9. 加载 modules/09-data-migration.md → 数据层升级（如需要）
---
   10. 参考 appendix.md → 检查清单与回滚策略
```

---

## 使用示例

### 场景1：传统Spring MVC + 专有框架升级到Boot

```yaml
input:
  project_type: "Spring MVC 4.x + Dorado 7"
  java_version: "8"
  target: "Spring Boot 2.7.x"
  
workflow:
  1. "读取modules/01-analysis.md获取升级策略"
  2. "读取modules/02-component-compat.md分析组件兼容性"
  3. "读取modules/03-risk-migration.md评估风险"
  4. "读取modules/07-dorado-framework.md执行专有框架迁移四步法"
     "  - ServletRegistrationBean注册DoradoServlet"
     "  - @ImportResource按依赖序加载Dorado Context"
     "  - ServletContextInitializer初始化failSafeContext"
     "  - Configure存储追加子Context配置"
  5. "读取modules/08-config-migration.md处理Profile归并和PropertyPlaceholder"
  6. "读取modules/09-data-migration.md处理Redis/EhCache等数据层升级"
  7. "生成改造方案"
```

### 场景2：Spring Boot 2.x升级到3.x

```yaml
input:
  project_type: "Spring Boot 2.7.x"
  java_version: "17"
  target: "Spring Boot 3.2.x"
  
workflow:
  1. "读取modules/01-analysis.md确认升级路径"
  2. "重点读取modules/02-component-compat.md中的javax→jakarta变更"
  3. "读取modules/03-risk-migration.md获取OpenRewrite配置"
  4. "读取modules/09-data-migration.md检查Redis缓存升级（如使用自定义RedisCacheManager）"
  5. "生成分阶段改造方案"
```

### 场景3：传统Spring MVC升级 + 配置体系改造

```yaml
input:
  project_type: "Spring MVC 5.x + 7个独立properties文件"
  java_version: "8"
  target: "Spring Boot 2.7.x"
  
workflow:
  1. "读取modules/01-analysis.md -> 分析配置体系"
  2. "读取modules/08-config-migration.md执行配置迁移"
     "  - Maven Profile归并到Spring Boot Profile"
     "  - PropertyPlaceholderConfigurer升级"
     "  - 密码解密链路重建（PropertySource装饰器）"
     "  - SystemEnv重构（ResourceBundle->@Value）"
  3. "读取modules/05-faq-debug.md排查配置相关问题"
  4. "生成改造方案"
```

---

## 常用命令

```bash
# 查看项目依赖树
mvn dependency:tree

# 查看特定依赖
mvn dependency:tree -Dincludes=org.hibernate:*:*:*

# 查看Woodstox/StAX依赖（常见版本冲突）
mvn dependency:tree -Dincludes="*woodstox*,*stax2*,*jackson-dataformat-xml*"

# 查看Tomcat依赖（检查嵌入式Tomcat是否被排除）
mvn dependency:tree -Dincludes="*tomcat-embed*"

# 预览OpenRewrite变更
mvn rewrite:dryRun

# 执行OpenRewrite迁移
mvn rewrite:run

# 启动调试模式
java -jar app.jar --debug

# 查看自动配置报告
# 访问 /actuator/configprops
```
