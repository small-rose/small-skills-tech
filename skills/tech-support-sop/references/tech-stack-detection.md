# 技术栈检测规则

## 检测概述

本文件定义了技术问题解答 SOP 中的技术栈检测规则，用于自动识别用户问题涉及的技术栈。

---

## 技术大类识别

### 关键词匹配规则

| 技术大类 | 关键词 | 识别优先级 |
|---------|--------|-----------|
| **Java** | java, spring, maven, gradle, jdk, jvm, tomcat, jetty, mybatis, hibernate | 高 |
| **Python** | python, pip, django, flask, fastapi, pandas, numpy, scipy, scikit-learn | 高 |
| **Nginx** | nginx, 反向代理, 负载均衡, upstream, proxy_pass | 高 |
| **Node.js** | node, npm, yarn, pnpm, express, koa, nextjs, nuxtjs, react, vue, angular | 高 |
| **Docker** | docker, container, dockerfile, docker-compose, 容器, 镜像 | 高 |
| **MySQL** | mysql, mariadb, 数据库, sql, 查询 | 中 |
| **PostgreSQL** | postgresql, postgres, psql, 数据库 | 中 |
| **Redis** | redis, 缓存, cache, session | 中 |
| **Kubernetes** | kubernetes, k8s, pod, service, deployment, cluster | 中 |
| **Git** | git, github, gitlab, gitea, 仓库, 版本控制 | 低 |
| **Linux** | linux, ubuntu, centos, debian, fedora, 系统, 服务器 | 低 |
| **Windows** | windows, iis, powershell, .net, c# | 低 |
| **Mac** | macos, mac, xcode, swift | 低 |

### 文件扩展名识别

| 文件类型 | 技术栈 | 说明 |
|---------|--------|------|
| `.java` | Java | Java 源代码 |
| `.py` | Python | Python 源代码 |
| `.js` | Node.js | JavaScript 文件 |
| `.ts` | Node.js/TypeScript | TypeScript 文件 |
| `.go` | Go | Go 源代码 |
| `.rs` | Rust | Rust 源代码 |
| `.rb` | Ruby | Ruby 源代码 |
| `.php` | PHP | PHP 文件 |
| `.conf` | Nginx/Linux | 配置文件 |
| `.yml` / `.yaml` | 多种 | YAML 配置文件 |
| `.json` | 多种 | JSON 配置文件 |
| `.xml` | Java/多种 | XML 配置文件 |
| `Dockerfile` | Docker | Docker 构建文件 |
| `docker-compose.yml` | Docker | Docker Compose 文件 |

### 配置文件识别

| 文件路径/名称 | 技术栈 | 说明 |
|-------------|--------|------|
| `pom.xml` | Java/Maven | Maven 项目配置 |
| `build.gradle` | Java/Gradle | Gradle 项目配置 |
| `package.json` | Node.js | npm 包配置 |
| `requirements.txt` | Python | Python 依赖 |
| `pyproject.toml` | Python | Python 项目配置 |
| `setup.py` | Python | Python 安装配置 |
| `Cargo.toml` | Rust | Rust 项目配置 |
| `go.mod` | Go | Go 模块配置 |
| `Gemfile` | Ruby | Ruby 依赖配置 |
| `composer.json` | PHP | PHP 依赖配置 |
| `nginx.conf` | Nginx | Nginx 主配置 |
| `application.yml` | Spring Boot | Spring Boot 配置 |
| `application.properties` | Spring Boot | Spring Boot 属性配置 |
| `settings.py` | Django | Django 配置文件 |
| `config.js` | Node.js | Node.js 配置文件 |

---

## 技术小类识别

### Java 技术小类

| 技术小类 | 识别特征 | 关键词 |
|---------|---------|--------|
| **Spring Boot** | @SpringBootApplication, application.yml | spring, springboot, spring-boot |
| **Spring Framework** | @Component, @Service, @Repository | spring, spring-framework |
| **MyBatis** | Mapper.xml, @Mapper | mybatis, orm, 持久层 |
| **Hibernate** | @Entity, @Table | hibernate, jpa, orm |
| **Maven** | pom.xml, mvn | maven, 构建, 依赖 |
| **Gradle** | build.gradle, gradle | gradle, 构建 |
| **Tomcat** | web.xml, servlet | tomcat, web 服务器 |
| **Jetty** | jetty.xml, embedded | jetty, 嵌入式服务器 |

### Python 技术小类

| 技术小类 | 识别特征 | 关键词 |
|---------|---------|--------|
| **Django** | settings.py, manage.py, models.py | django, web 框架 |
| **Flask** | app.py, @app.route | flask, micro, web |
| **FastAPI** | main.py, @app.get, Pydantic | fastapi, async, api |
| **Pandas** | DataFrame, Series | pandas, 数据分析, 数据处理 |
| **NumPy** | ndarray, array | numpy, 数值计算 |
| **Scipy** | scipy.optimize, scipy.stats | scipy, 科学计算 |
| **Scikit-learn** | sklearn, fit, predict | 机器学习, ml |
| **Celery** | task, celery | celery, 异步任务 |
| **SQLAlchemy** | Engine, Session | sqlalchemy, orm |

### Nginx 技术小类

| 技术小类 | 识别特征 | 关键词 |
|---------|---------|--------|
| **反向代理** | proxy_pass | 反向代理, proxy |
| **负载均衡** | upstream | 负载均衡, load balance |
| **SSL/TLS** | ssl_certificate, listen 443 | ssl, https, 证书 |
| **WebSocket** | proxy_set_header Upgrade | websocket, ws |
| **静态文件服务** | root, location / | 静态文件, static |
| **限流** | limit_req, limit_conn | 限流, rate limit |

### Node.js 技术小类

| 技术小类 | 识别特征 | 关键词 |
|---------|---------|--------|
| **Express** | app.get, app.post, middleware | express, web 框架 |
| **Koa** | app.use, ctx | koa, async |
| **Next.js** | pages/, app/, getServerSideProps | nextjs, ssr, react |
| **Nuxt.js** | pages/, layouts/, nuxt.config | nuxtjs, ssr, vue |
| **NestJS** | @Controller, @Injectable | nestjs, 微服务 |
| **TypeORM** | @Entity, @Column | typeorm, orm |

### Docker 技术小类

| 技术小类 | 识别特征 | 关键词 |
|---------|---------|--------|
| **容器管理** | docker run, docker ps | 容器, container |
| **Dockerfile** | FROM, RUN, COPY, CMD | 镜像构建, image |
| **Docker Compose** | services, networks, volumes | compose, 多容器 |
| **Docker Network** | network, bridge, overlay | 网络, network |
| **Docker Volume** | volume, mount | 存储, volume |

---

## 版本检测方法

### Java 版本检测

```bash
# 检测 JDK 版本
java -version

# 检测 Maven 版本
mvn -version

# 检测 Gradle 版本
gradle -version

# 从 pom.xml 提取版本
cat pom.xml | grep -E "<version>|<parent>" | head -10

# 从 build.gradle 提取版本
cat build.gradle | grep -E "version|sourceCompatibility"
```

### Python 版本检测

```bash
# 检测 Python 版本
python --version
python3 --version

# 检测 pip 版本
pip --version

# 从 requirements.txt 提取版本
cat requirements.txt

# 从 pyproject.toml 提取版本
cat pyproject.toml | grep -E "version|python"
```

### Nginx 版本检测

```bash
# 检测 Nginx 版本
nginx -v

# 从配置文件提取信息
cat /etc/nginx/nginx.conf | head -20
```

### Node.js 版本检测

```bash
# 检测 Node.js 版本
node --version

# 检测 npm 版本
npm --version

# 检测 yarn 版本
yarn --version

# 从 package.json 提取版本
cat package.json | grep -E "version|engines"
```

### Docker 版本检测

```bash
# 检测 Docker 版本
docker --version

# 检测 Docker Compose 版本
docker-compose --version
docker compose version

# 从 Dockerfile 提取基础镜像
cat Dockerfile | grep "^FROM"
```

---

## 检测流程

```
用户提问
    ↓
提取关键词
    ↓
匹配技术大类
    ↓
├─ 匹配成功 → 识别技术小类
└─ 匹配失败 → 询问用户具体技术栈
    ↓
识别技术小类
    ↓
├─ 匹配成功 → 检测版本信息
└─ 匹配失败 → 询问用户具体组件
    ↓
检测版本信息
    ↓
├─ 用户提供版本 → 记录版本
└─ 用户未提供 → 主动询问版本
    ↓
完成技术栈识别
```

---

## 动态学习规则

### 新技术栈添加

当用户提问涉及未知技术栈时：

1. 从用户提问中提取技术栈信息
2. 添加到 `known-tech-stacks.json`
3. 标记为"待验证"
4. 后续验证后更新状态

### 版本信息更新

当用户反馈新版本信息时：

1. 更新 `known-tech-stacks.json` 中的版本列表
2. 验证新版本的官方文档
3. 更新常见问题列表

### 常见问题积累

当发现新的常见问题时：

1. 添加到对应技术栈的 `common_issues`
2. 记录问题描述和解决方案
3. 更新验证状态

---

## 检测示例

### 示例 1: Java 问题

**用户提问**: "我的 Spring Boot 应用启动时报错"

**检测结果**:
- 技术大类: Java
- 技术小类: Spring Boot
- 识别依据: 关键词 "Spring Boot"
- 版本信息: 未提供（需要询问）

### 示例 2: Python 问题

**用户提问**: "Django 项目迁移数据库失败"

**检测结果**:
- 技术大类: Python
- 技术小类: Django
- 识别依据: 关键词 "Django" + "迁移数据库"
- 版本信息: 未提供（需要询问）

### 示例 3: Nginx 问题

**用户提问**: "nginx 反向代理 502 Bad Gateway"

**检测结果**:
- 技术大类: Nginx
- 技术小类: 反向代理
- 识别依据: 关键词 "nginx" + "反向代理" + "502"
- 版本信息: 未提供（需要询问）

### 示例 4: Docker 问题

**用户提问**: "docker-compose 启动服务失败"

**检测结果**:
- 技术大类: Docker
- 技术小类: Docker Compose
- 识别依据: 关键词 "docker-compose" + "启动服务"
- 版本信息: 未提供（需要询问）
