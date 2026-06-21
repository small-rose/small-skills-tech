# FMS 项目：Spring Boot 2.7.18 升级实战案例

## 背景

**FMS**（费用跟单系统）是一个遗留企业应用，构建于 Spring Framework 5.2.x 之上，采用传统 `web.xml` + WAR 部署模式。项目没有 Spring Boot 依赖管理，依赖手动维护数十个组件的版本。

**目标**：升级到 Spring Boot 2.7.18（Spring Framework 5.3.x），保持 Java 8，最小化代码改动。

**技术栈**：
- Java 8，Maven 多模块项目
- Spring Framework 5.2.24 → 5.3.31（通过 Boot BOM）
- Dorado Framework 7.4.1（专有富客户端 Web 框架）
- Hibernate 5.4.33 → 5.6.15.Final
- Spring Data Redis 1.7.2 → 2.7.18
- Spring AMQP/Rabbit 1.3.9 → 2.4.17
- Apache CXF 3.1.4（保持）
- EhCache 2.6.9（保持）
- Oracle → MySQL 迁移（独立工作）
- Activiti 5.16.3（保持）
- Woodstox（冲突解决：排除旧传递依赖）

## 关键数据

| 指标 | 值 |
|--------|-------|
| 升级版本数 | v1.0 → v1.24 |
| 升级耗时 | ~1 天（密集） |
| 修改文件数 | ~20+（POM、Java 配置、XML 配置、资源文件）|
| Web.xml 迁移项 | 24 个 Servlet + 4 个 Filter + 4 个 Listener |
| Dorado Context 问题 | 6 个（common、config、data、view、web、child）|
| Cache Manager 重写 | 2 个（MyRedisCacheManager + CompositeCacheManager）|
| Property placeholder 问题 | 5+（jdbc、components、configure、solr、spring）|
| 循环依赖修复 | 1 个（Activiti WF ↔ Task Service）|
| Woodstox 冲突尝试 | 2 次（错误方案、正确方案）|
| Profile 环境 | 3 个（local、dev、prod）|

## 案例文档

| 文档 | 来源 | 说明 |
|----------|--------|------|
| `analysis-report.md` | `Spring Boot 2.7.18升级分析报告.md` + `upgrade.md` 第1章+附录 | 升级前分析：兼容性、风险、方案 |
| `upgrade-log.md` | `upgrade.md`（v1.1~v1.24 过程） | 完整升级过程及各问题根因分析 |
| `dorado-resources.md` | `dorado-resources-guide.md` | Dorado 框架资源处理模式 |
| `webapp-upgrade.md` | `webapp-upgrade-guide.md` | webapp 目录和 classpath 迁移指南 |

## 核心经验

1. **Dorado 框架是最难的部分** — 其 Context 初始化链深度耦合 Servlet API，需要在嵌入式 Tomcat 中仔细模拟
2. **Property placeholder 链条至关重要** — 在遗留应用中，`.properties` 文件在每个层级加载（Spring、Dorado、自定义）；缺一个就会破坏无关功能
3. **版本冲突诊断利器** — `mvn dependency:tree` 是关键。Woodstox 冲突浪费了 2 次尝试才找到正确的排除策略
4. **web.xml → Java 配置** — 必须使用 `ServletRegistrationBean`/`FilterRegistrationBean`；`@ServletComponentScan` 只对带 `@WebServlet` 注解的类有效
5. **缓存 API 弃用** — Spring Boot 2.x 缓存抽象变化显著；`RedisCacheConfiguration` 变为不可变类
6. **默认禁止循环依赖** — Spring Boot 2.6+ 默认禁止循环引用，需要设置 `allow-circular-references: true` 或重构代码

## 相关资源

- SKILL：[springboot-upgrade](../../skills/springboot-upgrade/SKILL.md)
- 模板：[upgrade-plan-template](../../skills/springboot-upgrade/templates/upgrade-plan-template.md)
- 模板：[upgrade-log-template](../../skills/springboot-upgrade/templates/upgrade-log-template.md)
