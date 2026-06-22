# tech-support-sop

技术问题解答标准操作流程（SOP）— 当用户咨询技术问题时自动触发，提供结构化、有据可查的解答。

---

## Features

- **自动检测技术栈** — 从提问中识别技术大类、小类、版本
- **来源验证** — 自动验证 URL 有效性，标注可信度
- **测试评估** — 评估测试复杂度，询问用户环境
- **动态学习** — 新技术栈自动添加到知识库
- **快速响应** — 简单问题直接回答，无需完整流程

## Trigger Keywords

| 问题类型 | 关键词示例 |
|---------|-----------|
| 技术咨询 | "如何解决..."、"怎么配置..." |
| 错误排查 | "报错了..."、"运行失败..." |
| 环境配置 | "怎么安装..."、"环境变量..." |
| 代码调试 | "这段代码有问题..." |
| 性能优化 | "太慢了..."、"优化..." |
| 部署相关 | "部署..."、"上线..." |

## Supported Tech Stacks

| 技术大类 | 技术小类 |
|---------|---------|
| Java | Spring Boot, Spring Framework, MyBatis, Maven, Gradle |
| Python | Django, Flask, FastAPI, Pandas, NumPy |
| Nginx | 反向代理, 负载均衡, SSL/TLS |
| Node.js | Express, Koa, Next.js |
| Docker | 容器管理, Dockerfile, Docker Compose |
| Database | MySQL, PostgreSQL, Redis |
| Messaging | RabbitMQ, Kafka |
| Search | Elasticsearch |
| DevOps | Kubernetes, Git, Linux |

## Structure

```
tech-support-sop/
├── SKILL.md                    # Skill 定义
├── references/
│   ├── known-tech-stacks.json  # 技术栈知识库（动态扩展）
│   ├── answer-template.md      # 回答模板
│   ├── tech-stack-detection.md # 技术栈检测规则
│   ├── source-verification.md  # 来源验证规范
│   ├── test-case-guidelines.md # 测试用例指南
│   └── troubleshooting-methods.md # 故障排查方法论
├── templates/
│   ├── question-analysis.md    # 问题分析模板
│   ├── verification-report.md  # 验证报告模板
│   ├── environment-check.md    # 环境检查模板
│   └── test-script.md          # 测试脚本模板
└── scripts/
    ├── detect-tech-stack.ps1   # 技术栈检测脚本
    ├── verify-url.ps1          # URL 验证脚本
    └── check-environment.ps1   # 环境检查脚本
```

## Installation

```bash
# Install via opencode
opencode skill install https://github.com/small-rose/small-skills-tech skills/tech-support-sop

# Or search directly
# /find-skill tech-support-sop
```

## Usage

安装后在对话中提及以下关键词触发：

- "我的 Spring Boot 应用启动报错"
- "nginx 反向代理 502"
- "Django 迁移数据库失败"
- "Docker 容器启动失败"
- "Python 版本查询"
- "如何配置环境变量"

## Core Workflow

```
用户提问
    ↓
快速路径判断
    ├─ 简单问题 → 直接回答
    └─ 复杂问题 → 标准 SOP 流程
         ├─ 阶段 1: 问题分析与分类
         ├─ 阶段 2: 环境识别与确认
         ├─ 阶段 3: 资料搜集与验证
         ├─ 阶段 4: 问题解答与引用
         ├─ 阶段 5: 验证与测试
         └─ 阶段 6: 文档化与反馈
```

## Key Principles

1. **禁止猜测** — 信息不足时必须主动询问用户
2. **强制引用** — 每个解决方案必须附带来源引用
3. **版本验证** — 必须识别并验证组件版本
4. **环境检测** — 自动检测用户工程环境
5. **测试验证** — 提供验证案例和回归测试

## License

[Apache License 2.0](../../LICENSE)
