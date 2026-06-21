# FMS Project: Spring Boot 2.7.18 Upgrade Case Study

## Background

**FMS** (Fee Management System) is a legacy enterprise application built on Spring Framework 5.2.x with a traditional `web.xml` + WAR deployment model. The project had no Spring Boot dependency management and relied on manually managed versions across dozens of components.

**Goal**: Migrate to Spring Boot 2.7.18 (Spring Framework 5.3.x) while keeping Java 8 and minimizing code changes.

**Tech Stack**:
- Java 8, Maven multi-module project
- Spring Framework 5.2.24 → 5.3.31 (via Boot BOM)
- Dorado Framework 7.4.1 (proprietary rich-client web framework)
- Hibernate 5.4.33 → 5.6.15.Final
- Spring Data Redis 1.7.2 → 2.7.18
- Spring AMQP/Rabbit 1.3.9 → 2.4.17
- Apache CXF 3.1.4 (kept)
- EhCache 2.6.9 (kept)
- Oracle → MySQL migration (separate effort)
- Activiti 5.16.3 (kept)
- Woodstox (conflict resolution: exclude old transitive deps)

## Key Statistics

| Metric | Value |
|--------|-------|
| Upgrade versions | v1.0 → v1.25 |
| Days in upgrade | ~1 (intensive) |
| Files modified | ~20+ (POM, Java config, XML config, resources) |
| Web.xml items migrated | 24 Servlets + 4 Filters + 4 Listeners |
| Dorado Context issues resolved | 6 (common, config, data, view, web, child) |
| Cache Manager rework | 2 (MyRedisCacheManager + CompositeCacheManager) |
| Property placeholder issues | 5+ (jdbc, components, configure, solr, spring) |
| Circular dependencies fixed | 1 (Activiti WF ↔ Task Service) |
| Woodstox conflict attempts | 2 (wrong, correct) |
| Profile environments | 3 (local, dev, prod) |

## Case Documents

| Document | Source | Description |
|----------|--------|-------------|
| `analysis-report.md` | `Spring Boot 2.7.18升级分析报告.md` + `upgrade.md` ch1 + appendices | Pre-upgrade analysis: compatibility, risk, plan |
| `upgrade-log.md` | `upgrade.md` (v1.1~v1.24 process) | Full upgrade journey with root cause analysis |
| `dorado-resources.md` | `dorado-resources-guide.md` | Dorado framework resource handling pattern |
| `webapp-upgrade.md` | `webapp-upgrade-guide.md` | webapp directory and classpath migration guide |

## Key Lessons

1. **Dorado Framework is the hardest part** — its Context initialization chain is deeply coupled to Servlet API and requires careful simulation in embedded Tomcat
2. **Property placeholder chain matters** — in a legacy app, `.properties` files are loaded at every level (Spring, Dorado, custom); missing any one breaks unrelated features
3. **The version conflict oracle** — `mvn dependency:tree` is critical. Woodstox conflicts wasted 2 attempts before the right exclusion strategy
4. **web.xml → Java Config** — must use `ServletRegistrationBean`/`FilterRegistrationBean`; `@ServletComponentScan` only works with `@WebServlet` annotations
5. **Cache API deprecation** — Spring Boot 2.x cache abstractions changed significantly; `RedisCacheConfiguration` became immutable
6. **Circular dependency by default** — Spring Boot 2.6+ forbids circular references by default; need `allow-circular-references: true` or refactor
7. **System-scoped JARs invisible to ClassLoader** — `DoradoLoader.preload()` scans `META-INF/dorado-package.properties` via `ClassLoader.getResources()` but misses `<scope>system</scope>` JARs in embedded Tomcat. Workaround: add explicit `@ImportResource` for the add-on's context.xml

## Related Resources

- SKILL: [springboot-upgrade](../../skills/springboot-upgrade/SKILL.md)
- Templates: [upgrade-plan-template](../../skills/springboot-upgrade/templates/upgrade-plan-template.md)
- Templates: [upgrade-log-template](../../skills/springboot-upgrade/templates/upgrade-log-template.md)
