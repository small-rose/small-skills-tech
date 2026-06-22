# 来源验证规范

## 验证概述

本文件定义了技术问题解答 SOP 中的来源验证规范，用于确保所有答案都有可靠的来源引用。

---

## 来源权威性层级

### 层级定义

| 层级 | 来源类型 | 可信度 | 说明 |
|------|---------|--------|------|
| 1 | 官方文档 | ⭐⭐⭐⭐⭐ | 技术官方发布的文档 |
| 2 | 官方 GitHub | ⭐⭐⭐⭐⭐ | 技术官方维护的 GitHub 仓库 |
| 3 | 权威社区 | ⭐⭐⭐⭐ | Stack Overflow、GitHub Issues 等 |
| 4 | 官方博客 | ⭐⭐⭐⭐ | 技术官方发布的博客文章 |
| 5 | 技术书籍 | ⭐⭐⭐ | 出版社出版的技术书籍 |
| 6 | 个人博客 | ⭐⭐ | 个人技术博客，需要验证 |
| 7 | AI 生成 | ⭐ | AI 生成的内容，必须验证 |

### 来源类型识别

#### 官方文档识别

| 技术 | 官方文档 URL 模式 | 示例 |
|------|------------------|------|
| Java | `*.oracle.com`, `*.java.com` | https://docs.oracle.com/en/java/ |
| Spring | `spring.io/projects/*` | https://spring.io/projects/spring-boot |
| Python | `python.org`, `docs.python.org` | https://docs.python.org/3/ |
| Django | `djangoproject.com` | https://docs.djangoproject.com/ |
| Flask | `flask.palletsprojects.com` | https://flask.palletsprojects.com/ |
| FastAPI | `fastapi.tiangolo.com` | https://fastapi.tiangolo.com/ |
| Nginx | `nginx.org` | https://nginx.org/en/docs/ |
| Node.js | `nodejs.org`, `npmjs.com` | https://nodejs.org/en/docs/ |
| Docker | `docs.docker.com` | https://docs.docker.com/ |
| Kubernetes | `kubernetes.io` | https://kubernetes.io/docs/ |

#### 官方 GitHub 识别

| 技术 | GitHub 仓库模式 | 示例 |
|------|-----------------|------|
| Spring Boot | `spring-projects/spring-boot` | https://github.com/spring-projects/spring-boot |
| Django | `django/django` | https://github.com/django/django |
| Flask | `pallets/flask` | https://github.com/pallets/flask |
| FastAPI | `tiangolo/fastapi` | https://github.com/tiangolo/fastapi |
| Nginx | `nginx/nginx` | https://github.com/nginx/nginx |
| Node.js | `nodejs/node` | https://github.com/nodejs/node |
| Docker | `docker/cli` | https://github.com/docker/cli |

#### 权威社区识别

| 社区 | URL 模式 | 可信度 |
|------|---------|--------|
| Stack Overflow | `stackoverflow.com` | ⭐⭐⭐⭐ |
| GitHub Issues | `github.com/*/issues` | ⭐⭐⭐⭐ |
| GitHub Discussions | `github.com/*/discussions` | ⭐⭐⭐⭐ |
| Dev.to | `dev.to` | ⭐⭐⭐ |
| Medium | `medium.com` | ⭐⭐⭐ |
| CSDN | `blog.csdn.net` | ⭐⭐ |
| 知乎 | `zhuanlan.zhihu.com` | ⭐⭐ |

---

## 验证流程

### 链接验证流程

```
获取来源 URL
    ↓
使用 webfetch 工具访问
    ↓
├─ 成功 → 记录验证状态：✅ 已验证
└─ 失败 → 记录失败原因
         ├─ 404 → 页面不存在
         ├─ 403 → 访问被拒绝
         ├─ 超时 → 连接超时
         ├─ DNS 错误 → 域名无法解析
         └─ 其他 → 网络错误
```

### 验证结果格式

#### 成功验证

```markdown
**来源**: https://spring.io/projects/spring-boot
**验证状态**: ✅ 已验证（2026-06-18）
**可信度**: ⭐⭐⭐⭐⭐ 官方文档
**来源类型**: 官方文档
**摘要**: Spring Boot 是基于 Spring 框架的快速开发脚手架...
```

#### 验证失败

```markdown
**来源**: https://example.com/article
**验证状态**: ❌ 无法验证
**失败原因**: 404 页面不存在（该链接可能已失效）
**可信度**: ⭐⭐ 社区博客（未验证）
**来源类型**: 个人博客
**建议**: 请用户自行验证或提供替代链接
```

### 验证失败处理

| 失败原因 | 处理方式 | 示例 |
|---------|---------|------|
| 404 页面不存在 | 说明链接已失效，提供替代方案 | 链接可能已迁移到新地址 |
| 403 访问被拒绝 | 说明访问限制，提供摘要信息 | 需要登录或特定权限 |
| 连接超时 | 说明网络问题，建议用户自行验证 | 可能是网络不稳定 |
| DNS 错误 | 说明域名无法解析，提供已知信息 | 域名可能已变更 |
| 内容不相关 | 说明内容与问题不匹配，寻找其他来源 | 页面内容与预期不符 |

---

## 引用规范

### 标准引用格式

```markdown
**来源**: [完整 URL]
**验证状态**: [✅ 已验证 / ❌ 未验证]
**验证时间**: [日期，如 2026-06-18]
**可信度**: [⭐⭐⭐⭐⭐]
**来源类型**: [官方文档 / 社区讨论 / 博客文章 / ...]
**摘要**: [来源内容的简要摘要，1-2 句话]
```

### 未验证信息标注

```markdown
> ⚠️ **未经过验证**: 此解决方案来自社区讨论，尚未在官方文档中确认。
> 请在测试环境中验证后再应用到生产环境。
```

### 多来源引用

当解决方案来自多个来源时：

```markdown
**来源 1**: [URL 1] - [验证状态] - [可信度]
**来源 2**: [URL 2] - [验证状态] - [可信度]
**来源 3**: [URL 3] - [验证状态] - [可信度]
```

### 引用优先级规则

1. **优先使用官方文档**：如果官方文档有相关说明，优先引用
2. **其次使用官方 GitHub**：官方 GitHub 仓库的 Issues 和 Discussions
3. **再次使用权威社区**：Stack Overflow、GitHub Issues 等
4. **谨慎使用个人博客**：需要验证内容的准确性
5. **禁止使用 AI 生成内容**：不能作为唯一来源

---

## 信息不足处理

### 版本信息不足

当用户未提供版本信息时：

```markdown
## 版本信息缺失

为了更准确地解答，请提供以下信息：

- **操作系统**: [如 Windows 10、Ubuntu 22.04]
- **技术版本**: [如 Java 17、Python 3.11]
- **框架版本**: [如 Spring Boot 3.2.5、Django 4.2]
- **错误信息**: [完整的错误堆栈或错误消息]

提供这些信息后，我可以给出更精准的解决方案。
```

### 解决方案不足

当找不到可靠解决方案时：

```markdown
## 解决方案不足

根据当前搜索结果，未能找到完全匹配的官方解决方案。

**已找到的信息**:
- [来源 1]: [简要描述]
- [来源 2]: [简要描述]

**建议**:
1. 提供更多错误信息，以便进一步排查
2. 检查官方文档的最新版本
3. 在社区论坛提问，获取更多帮助

> ⚠️ 以下解决方案未经官方验证，请谨慎使用：
> [提供可能的解决方案，但明确标注未验证]
```

---

## 自动验证机制

### 验证脚本

使用 `scripts/verify-url.ps1` 脚本自动验证链接有效性：

```powershell
# 验证单个 URL
.\verify-url.ps1 -Url "https://example.com"

# 批量验证 URLs
.\verify-url.ps1 -UrlList "urls.txt"
```

### 验证结果存储

验证结果存储在内存中，每次对话会话结束后清空。如果需要持久化存储，可以写入日志文件。

### 验证失败重试

当链接验证失败时：
1. 重试 1 次（等待 5 秒）
2. 如果仍然失败，记录失败原因
3. 提供替代方案或建议用户自行验证

---

## 质量保证

### 验证检查清单

- [ ] 每个解决方案都有来源引用
- [ ] 来源 URL 已验证有效性
- [ ] 来源可信度已评估
- [ ] 未验证信息已标注
- [ ] 版本信息已确认
- [ ] 解决方案已测试（如果可能）

### 常见问题

| 问题 | 处理方式 |
|------|---------|
| 链接失效 | 寻找替代来源或标注为未验证 |
| 内容过时 | 检查最新版本，标注信息可能过时 |
| 版本不匹配 | 确认用户版本，提供对应版本的解决方案 |
| 多个来源冲突 | 优先使用官方文档，标注差异 |

---

## 更新日志

| 日期 | 版本 | 更新内容 |
|------|------|---------|
| 2026-06-18 | 1.0.0 | 初始版本 |
