# 测试脚本模板

## 脚本信息

- **脚本名称**: [脚本名称]
- **脚本类型**: [PowerShell/Bash/Python/...]
- **创建时间**: [日期时间]
- **用途**: [用途描述]

---

## 脚本说明

### 功能描述

[脚本功能的详细描述]

### 使用场景

- [场景 1]
- [场景 2]
- [场景 3]

### 前置条件

- [条件 1]
- [条件 2]
- [条件 3]

---

## 脚本代码

### PowerShell 脚本

```powershell
# [脚本名称].ps1
# [用途描述]

param(
    [Parameter(Mandatory=$true)]
    [string]$Param1,
    
    [Parameter(Mandatory=$false)]
    [string]$Param2 = "default"
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 日志函数
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

# 主函数
function Main {
    Write-Log "开始执行..."
    
    try {
        # 1. 环境检查
        Write-Log "检查环境..."
        # 检查代码...
        
        # 2. 执行操作
        Write-Log "执行操作..."
        # 操作代码...
        
        # 3. 验证结果
        Write-Log "验证结果..."
        # 验证代码...
        
        Write-Log "执行完成"
        return $true
    }
    catch {
        Write-Log "执行失败: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# 执行主函数
$result = Main
if ($result) {
    Write-Log "✅ 测试通过"
    exit 0
}
else {
    Write-Log "❌ 测试失败"
    exit 1
}
```

### Bash 脚本

```bash
#!/bin/bash
# [脚本名称].sh
# [用途描述]

set -e

# 日志函数
log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message"
}

# 主函数
main() {
    log "INFO" "开始执行..."
    
    # 1. 环境检查
    log "INFO" "检查环境..."
    # 检查代码...
    
    # 2. 执行操作
    log "INFO" "执行操作..."
    # 操作代码...
    
    # 3. 验证结果
    log "INFO" "验证结果..."
    # 验证代码...
    
    log "INFO" "执行完成"
    return 0
}

# 执行主函数
if main; then
    log "INFO" "✅ 测试通过"
    exit 0
else
    log "ERROR" "❌ 测试失败"
    exit 1
fi
```

### Python 脚本

```python
#!/usr/bin/env python3
# [脚本名称].py
# [用途描述]

import sys
import logging
from datetime import datetime

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)s] [%(levelname)s] %(message)s'
)
logger = logging.getLogger(__name__)

def main():
    """主函数"""
    logger.info("开始执行...")
    
    try:
        # 1. 环境检查
        logger.info("检查环境...")
        # 检查代码...
        
        # 2. 执行操作
        logger.info("执行操作...")
        # 操作代码...
        
        # 3. 验证结果
        logger.info("验证结果...")
        # 验证代码...
        
        logger.info("执行完成")
        return True
    except Exception as e:
        logger.error(f"执行失败: {e}")
        return False

if __name__ == "__main__":
    result = main()
    if result:
        logger.info("✅ 测试通过")
        sys.exit(0)
    else:
        logger.error("❌ 测试失败")
        sys.exit(1)
```

---

## 使用说明

### 参数说明

| 参数 | 类型 | 必需 | 默认值 | 说明 |
|------|------|------|--------|------|
| Param1 | string | 是 | - | [参数说明] |
| Param2 | string | 否 | "default" | [参数说明] |

### 执行方式

#### PowerShell
```powershell
.\[脚本名称].ps1 -Param1 "value1" -Param2 "value2"
```

#### Bash
```bash
chmod +x [脚本名称].sh
./[脚本名称].sh
```

#### Python
```bash
python [脚本名称].py
```

### 输出示例

```
[2026-06-18 10:00:00] [INFO] 开始执行...
[2026-06-18 10:00:01] [INFO] 检查环境...
[2026-06-18 10:00:02] [INFO] 执行操作...
[2026-06-18 10:00:03] [INFO] 验证结果...
[2026-06-18 10:00:04] [INFO] 执行完成
[2026-06-18 10:00:04] [INFO] ✅ 测试通过
```

---

## 注意事项

### 使用注意

1. **权限要求**: [如需要管理员权限]
2. **环境要求**: [如需要特定版本]
3. **网络要求**: [如需要网络连接]
4. **数据备份**: [如需要备份数据]

### 常见问题

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| [问题 1] | [原因] | [方案] |
| [问题 2] | [原因] | [方案] |

### 回滚方案

如果测试失败，执行以下命令回滚：

```powershell
# PowerShell 回滚命令
[回滚命令]
```

```bash
# Bash 回滚命令
[回滚命令]
```

---

## 更新日志

| 日期 | 版本 | 更新内容 |
|------|------|---------|
| 2026-06-18 | 1.0.0 | 初始版本 |
