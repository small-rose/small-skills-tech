# springboot-upgrade

Spring Boot 升级方案生成器 — 适用传统 Spring MVC / Spring Boot 低版本升级。

**适用项目特征**:
- 传统 Spring MVC + XML 配置 + WAR 部署
- 使用了专有框架（Dorado、Vaadin、ZK 等）
- 多数据源、多 Profile 配置体系
- 需要 Redis/EhCache/Hibernate 等组件版本兼容分析

**Skill 包含**:

| Module | Content |
|--------|---------|
| 01-analysis | 工程信息采集、升级类型判断、版本时间线 |
| 02-component-compat | 15 类组件兼容性深度分析 |
| 03-risk-migration | 风险评估、自动化迁移工具 |
| 04-multi-module-cicd | 多模块升级、CI/CD 部署 |
| 05-faq-debug | 26 个实战错误案例库 |
| 06-report | 升级报告模板、工作量评估 |
| 07-dorado-framework | 专有框架迁移四步法 |
| 08-config-migration | 配置体系迁移（Profile/解密/PropertyPlaceholder）|
| 09-data-migration | 数据层迁移（Redis/EhCache/Hibernate/AMQP）|

**触发词**:
`springboot升级` `springmvc迁移` `专有框架迁移` `版本兼容分析` `配置体系迁移`
