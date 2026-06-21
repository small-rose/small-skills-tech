# small-skills-tech

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

技术类 OpenCode SKILL 集合仓库。SKILL 是 OpenCode AI 助手的技能模块，用于解决特定技术问题。

---

## Skills

| Skill | 说明 |
|-------|------|
| [springboot-upgrade](./skills/springboot-upgrade/) | Spring Boot 升级方案生成器 — 分析组件兼容性、评估风险、生成详细改造方案 |

---

## 安装

```bash
# 通过 opencode 安装
opencode skill install https://github.com/small-rose/small-skills-tech skills/springboot-upgrade

# 或在对话中搜索
# /find-skill springboot-upgrade
```

---

## 使用

安装后在对话中提及以下关键词触发：

- "帮我分析这个项目升级到 Spring Boot"
- "Spring MVC 迁移到 Spring Boot"
- "版本兼容分析"
- "专有框架迁移"

---

## 实战案例

真实世界的升级案例，补充 SKILL 方法论。

| 案例 | 说明 |
|------|------|
| [FMS Spring Boot 升级](./case-studies/fms-springboot-upgrade/) | FMS 费用跟单系统从 Spring 5.2 升级到 Boot 2.7.18 实战 |

每个案例包含分析报告、升级日志和专题指南。

---

## 模板

可复用的升级规划和记录模板，位于各 SKILL 的 `templates/` 目录下：

| 模板 | 所属 SKILL | 用途 |
|------|-----------|------|
| [upgrade-plan-template.md](./skills/springboot-upgrade/templates/upgrade-plan-template.md) | springboot-upgrade | 结构化升级分析方案 |
| [upgrade-log-template.md](./skills/springboot-upgrade/templates/upgrade-log-template.md) | springboot-upgrade | 版本化升级过程记录 |

---

## 目录结构

```
small-skills-tech/
├── README.md
├── LICENSE                      # Apache 2.0
├── .github/workflows/
│   └── validate.yml             # CI: SKILL.md 校验
├── case-studies/                # 实战案例
│   └── <case-name>/
│       ├── README.md
│       ├── analysis-report.md
│       └── upgrade-log.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md             # SKILL 定义（必选）
        ├── README.md            # SKILL 概述（推荐）
        ├── modules/             # 子模块（推荐用于复杂 SKILL）
        ├── templates/           # 可复用模板
        └── appendix.md          # 附加参考
```

---

## 贡献

想分享你自己的 SKILL？Fork 本仓库，在 `skills/` 下添加你的 SKILL，然后发起 Pull Request。请确保：

1. `SKILL.md` 包含完整的 frontmatter（`name`、`description`、`triggers`）
2. 模块使用 `01-` `02-` 前缀排序
3. 所有文件引用使用相对路径

---

## 许可证

[Apache License 2.0](LICENSE)
