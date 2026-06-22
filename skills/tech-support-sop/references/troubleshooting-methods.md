# 故障排查方法论

## 排查概述

本文件定义了技术问题解答 SOP 中的故障排查方法论，用于系统性地诊断和解决问题。

---

## 排查流程

### 标准排查流程

```
用户提问
    ↓
Step 1: 信息收集
    ↓
Step 2: 问题分类
    ↓
Step 3: 原因分析
    ↓
Step 4: 方案设计
    ↓
Step 5: 方案验证
    ↓
Step 6: 问题解决
```

### 详细流程

#### Step 1: 信息收集

**必要信息**：
- 技术栈（技术大类、小类、版本）
- 操作系统
- 错误信息（完整堆栈）
- 复现步骤
- 环境信息

**收集方式**：
1. 从用户提问中提取
2. 主动询问缺失信息
3. 使用脚本检测环境

#### Step 2: 问题分类

**问题类型**：
| 类型 | 说明 | 排查方向 |
|------|------|---------|
| 配置问题 | 配置项错误或缺失 | 检查配置文件 |
| 依赖问题 | 依赖冲突或缺失 | 检查依赖管理 |
| 运行时错误 | 程序运行时抛出异常 | 检查日志和代码 |
| 性能问题 | 程序运行缓慢或资源占用高 | 分析性能瓶颈 |
| 部署问题 | 部署过程中遇到的问题 | 检查部署流程 |
| 环境问题 | 开发环境配置问题 | 检查环境配置 |

#### Step 3: 原因分析

**分析方法**：
1. **日志分析**：查看错误日志，定位问题
2. **配置检查**：检查配置文件是否正确
3. **依赖检查**：检查依赖是否冲突或缺失
4. **环境检查**：检查环境是否满足要求
5. **代码审查**：检查代码是否存在问题

**分析工具**：
- 日志查看：`tail`, `grep`, `less`
- 配置检查：`nginx -t`, `mvn validate`
- 依赖检查：`mvn dependency:tree`, `pip list`
- 环境检查：`java -version`, `node --version`

#### Step 4: 方案设计

**设计原则**：
1. **优先官方方案**：优先使用官方文档中的解决方案
2. **优先简单方案**：优先使用简单的解决方案
3. **优先安全方案**：优先使用安全的解决方案
4. **提供备选方案**：提供多个备选方案

**方案类型**：
| 类型 | 说明 | 适用场景 |
|------|------|---------|
| 配置修改 | 修改配置文件 | 配置问题 |
| 依赖更新 | 更新或安装依赖 | 依赖问题 |
| 代码修复 | 修改代码 | 运行时错误 |
| 环境调整 | 调整环境配置 | 环境问题 |
| 重启服务 | 重启相关服务 | 临时解决方案 |

#### Step 5: 方案验证

**验证方式**：
1. **自动验证**：使用脚本自动验证
2. **手动验证**：手动执行验证命令
3. **测试验证**：在测试环境验证

**验证点**：
- [ ] 问题是否解决
- [ ] 是否引入新问题
- [ ] 是否符合预期

#### Step 6: 问题解决

**解决确认**：
1. 用户确认问题已解决
2. 验证修复效果
3. 记录解决方案

**后续跟进**：
1. 提供预防措施
2. 建议优化方案
3. 更新知识库

---

## 排查技巧

### 日志分析技巧

**关键日志位置**：
| 技术栈 | 日志位置 | 说明 |
|--------|---------|------|
| Java/Spring | `logs/`, `log/` | 应用日志 |
| Python/Django | `logs/`, `/var/log/` | 应用日志 |
| Nginx | `/var/log/nginx/` | 访问日志和错误日志 |
| Node.js | `logs/`, 控制台 | 应用日志 |
| Docker | `docker-compose logs` | 容器日志 |

**日志分析步骤**：
1. **定位日志文件**：找到相关日志文件
2. **过滤错误信息**：使用 grep 过滤错误信息
3. **查看上下文**：查看错误前后的上下文
4. **分析错误原因**：根据错误信息分析原因

**常用日志命令**：
```bash
# 查看最新日志
tail -f logs/app.log

# 过滤错误信息
grep -i "error" logs/app.log

# 查看特定时间段的日志
awk '/2026-06-18 10:00/,/2026-06-18 11:00/' logs/app.log

# 统计错误数量
grep -c "error" logs/app.log
```

### 配置检查技巧

**配置文件位置**：
| 技术栈 | 配置文件 | 说明 |
|--------|---------|------|
| Java/Spring | `application.yml`, `application.properties` | 应用配置 |
| Python/Django | `settings.py` | 应用配置 |
| Nginx | `nginx.conf`, `conf.d/` | 主配置和站点配置 |
| Node.js | `config.js`, `.env` | 应用配置 |
| Docker | `docker-compose.yml` | 容器配置 |

**配置检查步骤**：
1. **备份配置**：修改前备份配置
2. **检查语法**：检查配置语法是否正确
3. **检查路径**：检查配置路径是否正确
4. **检查权限**：检查配置文件权限

**常用配置检查命令**：
```bash
# Nginx 配置检查
nginx -t

# Java 配置检查
mvn validate

# Python 配置检查
python -m py_compile settings.py

# Docker 配置检查
docker-compose config
```

### 依赖检查技巧

**依赖管理工具**：
| 技术栈 | 工具 | 常用命令 |
|--------|------|---------|
| Java | Maven | `mvn dependency:tree` |
| Java | Gradle | `gradle dependencies` |
| Python | pip | `pip list`, `pip show` |
| Node.js | npm | `npm list`, `npm ls` |
| Node.js | yarn | `yarn list` |

**依赖检查步骤**：
1. **查看依赖树**：查看依赖关系
2. **检查版本**：检查依赖版本
3. **检查冲突**：检查依赖冲突
4. **检查缺失**：检查缺失依赖

**常用依赖检查命令**：
```bash
# Maven 依赖树
mvn dependency:tree

# pip 依赖列表
pip list

# npm 依赖树
npm list

# 检查特定依赖
mvn dependency:tree -Dincludes=org.springframework:spring-core
pip show requests
npm ls express
```

### 环境检查技巧

**环境检查清单**：
- [ ] 操作系统版本
- [ ] 运行时版本（JDK、Python、Node.js）
- [ ] 包管理工具版本（Maven、pip、npm）
- [ ] 磁盘空间
- [ ] 内存空间
- [ ] 网络连接
- [ ] 环境变量
- [ ] 文件权限

**常用环境检查命令**：
```bash
# 操作系统
uname -a
cat /etc/os-release

# Java
java -version
javac -version

# Python
python --version
pip --version

# Node.js
node --version
npm --version

# 磁盘空间
df -h

# 内存空间
free -h

# 网络连接
ping google.com
curl https://google.com
```

---

## 常见问题处理

### Java 常见问题

#### 问题 1: ClassNotFoundException

**排查步骤**：
1. 检查类路径是否正确
2. 检查依赖是否缺失
3. 检查打包配置

**解决方案**：
```bash
# 检查依赖
mvn dependency:tree

# 清理并重新打包
mvn clean package

# 检查打包结果
jar -tf target/*.jar | grep ClassName
```

#### 问题 2: Port Already in Use

**排查步骤**：
1. 检查占用端口的进程
2. 检查配置文件中的端口配置
3. 检查是否有其他服务占用

**解决方案**：
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID [进程ID] /F

# Linux/Mac
lsof -i :8080
kill [进程ID]
```

#### 问题 3: OutOfMemoryError

**排查步骤**：
1. 检查 JVM 内存配置
2. 检查是否有内存泄漏
3. 检查数据量是否过大

**解决方案**：
```bash
# 增加内存配置
java -Xmx2g -Xms1g -jar app.jar

# 监控内存使用
jmap -heap [进程ID]
jstat -gc [进程ID]
```

### Python 常见问题

#### 问题 1: ModuleNotFoundError

**排查步骤**：
1. 检查模块是否安装
2. 检查模块名称是否正确
3. 检查 Python 路径

**解决方案**：
```bash
# 安装模块
pip install module-name

# 检查已安装模块
pip list | grep module-name

# 检查 Python 路径
python -c "import sys; print(sys.path)"
```

#### 问题 2: SyntaxError

**排查步骤**：
1. 检查语法错误位置
2. 检查缩进是否正确
3. 检查括号是否匹配

**解决方案**：
```bash
# 语法检查
python -m py_compile script.py

# 使用 linter
flake8 script.py
pylint script.py
```

#### 问题 3: Permission Denied

**排查步骤**：
1. 检查文件权限
2. 检查目录权限
3. 检查是否需要管理员权限

**解决方案**：
```bash
# 修改文件权限
chmod +x script.py

# 使用 sudo（谨慎）
sudo python script.py

# 使用虚拟环境
python -m venv venv
source venv/bin/activate
```

### Nginx 常见问题

#### 问题 1: 502 Bad Gateway

**排查步骤**：
1. 检查后端服务是否运行
2. 检查 proxy_pass 配置
3. 检查网络连接

**解决方案**：
```bash
# 检查后端服务
curl http://localhost:8080

# 检查 Nginx 配置
nginx -t

# 查看错误日志
tail -f /var/log/nginx/error.log
```

#### 问题 2: 403 Forbidden

**排查步骤**：
1. 检查文件权限
2. 检查目录权限
3. 检查 SELinux 配置

**解决方案**：
```bash
# 修改文件权限
chmod 644 /path/to/file

# 修改目录权限
chmod 755 /path/to/directory

# 检查 SELinux
getenforce
setenforce 0  # 临时关闭
```

#### 问题 3: 404 Not Found

**排查步骤**：
1. 检查文件路径
2. 检查 root 配置
3. 检查 location 配置

**解决方案**：
```bash
# 检查文件是否存在
ls -la /path/to/file

# 检查 Nginx 配置
cat /etc/nginx/nginx.conf

# 重新加载配置
nginx -s reload
```

### Node.js 常见问题

#### 问题 1: Module Not Found

**排查步骤**：
1. 检查模块是否安装
2. 检查 node_modules 目录
3. 检查 package.json

**解决方案**：
```bash
# 安装模块
npm install module-name

# 清理并重新安装
rm -rf node_modules
npm install

# 检查模块
npm list module-name
```

#### 问题 2: Port Already in Use

**排查步骤**：
1. 检查占用端口的进程
2. 检查配置文件
3. 检查是否有其他服务占用

**解决方案**：
```bash
# 检查占用端口的进程
lsof -i :3000

# 杀死进程
kill -9 [进程ID]

# 使用其他端口
PORT=3001 node app.js
```

#### 问题 3: ENOSPC Error

**排查步骤**：
1. 检查磁盘空间
2. 检查 inodes 使用情况
3. 检查临时文件

**解决方案**：
```bash
# 检查磁盘空间
df -h

# 清理磁盘空间
rm -rf /tmp/*

# 检查 inodes
df -i
```

### Docker 常见问题

#### 问题 1: Container Exit Code 1

**排查步骤**：
1. 查看容器日志
2. 检查启动命令
3. 检查环境变量

**解决方案**：
```bash
# 查看容器日志
docker logs [容器ID]

# 进入容器调试
docker exec -it [容器ID] /bin/bash

# 检查容器状态
docker inspect [容器ID]
```

#### 问题 2: Port Binding Error

**排查步骤**：
1. 检查端口是否被占用
2. 检查 docker-compose.yml 配置
3. 检查 Docker 网络

**解决方案**：
```bash
# 检查端口占用
netstat -ano | findstr :8080

# 停止占用端口的服务
taskkill /PID [进程ID] /F

# 修改端口映射
ports:
  - "8081:8080"
```

#### 问题 3: No Space Left on Device

**排查步骤**：
1. 检查磁盘空间
2. 检查 Docker 镜像
3. 检查 Docker 容器

**解决方案**：
```bash
# 清理 Docker 镜像
docker image prune -a

# 清理 Docker 容器
docker container prune

# 清理 Docker 卷
docker volume prune
```

---

## 排查记录模板

```markdown
## 故障排查记录

### 问题信息
- **问题描述**: [问题描述]
- **技术栈**: [技术栈]
- **发生时间**: [时间]
- **影响范围**: [影响范围]

### 排查过程

#### Step 1: 信息收集
- **收集的信息**: [信息列表]
- **信息来源**: [来源]

#### Step 2: 问题分类
- **问题类型**: [类型]
- **严重程度**: [程度]

#### Step 3: 原因分析
- **可能原因**: [原因列表]
- **分析依据**: [依据]

#### Step 4: 方案设计
- **解决方案**: [方案描述]
- **方案来源**: [来源]
- **验证状态**: [状态]

#### Step 5: 方案验证
- **验证步骤**: [步骤]
- **验证结果**: [结果]
- **验证时间**: [时间]

#### Step 6: 问题解决
- **解决状态**: [状态]
- **解决时间**: [时间]
- **解决人**: [用户/AI]

### 后续跟进
- **预防措施**: [措施]
- **优化建议**: [建议]
- **知识库更新**: [更新内容]
```

---

## 排查最佳实践

### 原则

1. **系统性**：按照标准流程排查
2. **全面性**：收集所有相关信息
3. **准确性**：基于事实分析
4. **安全性**：确保操作安全
5. **可追溯性**：记录排查过程

### 注意事项

1. **备份数据**：修改前备份重要数据
2. **测试环境**：尽量在测试环境验证
3. **分步执行**：复杂问题分步解决
4. **及时回滚**：发现问题及时回滚
5. **记录过程**：详细记录排查过程

### 常见错误

| 错误 | 正确做法 |
|------|---------|
| 直接修改生产环境 | 先在测试环境验证 |
| 不备份直接修改 | 修改前备份 |
| 只看错误信息 | 查看完整日志 |
| 忽略环境因素 | 全面检查环境 |
| 不记录过程 | 详细记录排查过程 |
