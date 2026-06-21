# small-skills-tech

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

技术类 OpenCode SKILL 集合仓库。SKILL 是 OpenCode AI 助手的技能模块，用于解决特定技术问题。

A collection of technical OpenCode SKILLs. SKILLs are skill modules for the OpenCode AI assistant to solve specific technical problems.

---

## Skills

| Skill | Description | 说明 |
|-------|-------------|------|
| [springboot-upgrade](./skills/springboot-upgrade/) | Spring Boot migration plan generator — analyzes component compatibility, assesses risks, and generates detailed upgrade plans | Spring Boot 升级方案生成器 — 分析组件兼容性、评估风险、生成详细改造方案 |

---

## Installation

```bash
# Install via opencode
opencode skill install https://github.com/small-rose/small-skills-tech skills/springboot-upgrade

# Or search directly
# /find-skill springboot-upgrade
```

---

## Usage

Once installed, trigger the skill by mentioning related keywords in conversation:

- "帮我分析这个项目升级到 Spring Boot"
- "Spring MVC 迁移到 Spring Boot"
- "版本兼容分析"
- "专有框架迁移"

---

## Case Studies

Real-world upgrade cases to complement the SKILL's methodology.

| Case | Description | 说明 |
|------|-------------|------|
| [FMS Spring Boot Upgrade](./case-studies/fms-springboot-upgrade/) | FMS fee management system from Spring 5.2 to Boot 2.7.18 | FMS费用跟单系统从 Spring 5.2 升级到 Boot 2.7.18 实战 |

Each case study contains an analysis report, upgrade log, and topic-specific guides.

---

## Templates

Reusable templates for planning and documenting upgrades, located under each SKILL's `templates/` directory:

| Template | SKILL | Purpose |
|----------|-------|---------|
| [upgrade-plan-template.md](./skills/springboot-upgrade/templates/upgrade-plan-template.md) | springboot-upgrade | Structured upgrade analysis plan |
| [upgrade-log-template.md](./skills/springboot-upgrade/templates/upgrade-log-template.md) | springboot-upgrade | Versioned upgrade process log |

---

## Structure

```
small-skills-tech/
├── README.md
├── LICENSE                      # Apache 2.0
├── .github/workflows/
│   └── validate.yml             # CI: validate SKILL.md frontmatter
├── case-studies/                # Real-world upgrade case studies
│   └── <case-name>/
│       ├── README.md
│       ├── analysis-report.md
│       └── upgrade-log.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md             # Skill definition (required)
        ├── README.md            # Skill overview (recommended)
        ├── modules/             # Sub-modules (recommended for complex skills)
        ├── templates/           # Reusable templates
        └── appendix.md          # Additional reference
```

---

## Contributing

Want to share your own SKILL? Fork this repo, add your skill under `skills/`, and open a pull request. Make sure:

1. `SKILL.md` has valid frontmatter (`name`, `description`, `triggers`)
2. Modules are numbered with `01-` `02-` prefix for ordering
3. All file references are relative paths

---

## License

[Apache License 2.0](LICENSE)
