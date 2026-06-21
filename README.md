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
opencode skill install https://github.com/small-skills-tech/small-skills-tech skills/springboot-upgrade

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

## Structure

```
small-skills-tech/
├── README.md
├── LICENSE                      # Apache 2.0
├── .github/workflows/
│   └── validate.yml             # CI: validate SKILL.md frontmatter
└── skills/
    └── <skill-name>/
        ├── SKILL.md             # Skill definition (required)
        ├── README.md            # Skill overview (recommended)
        ├── modules/             # Sub-modules (recommended for complex skills)
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
