# check-environment.ps1
# 环境检查脚本（兼容 PowerShell 2.0+）

# 兼容性函数：获取 WMI/CIM 对象
function Get-SystemInfo {
    param([string]$ClassName)
    
    if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        return Get-CimInstance -ClassName $ClassName
    }
    else {
        return Get-WmiObject -Class $ClassName
    }
}

function Check-Java {
    Write-Host "=== Java 环境 ===" -ForegroundColor Cyan
    
    $javaVersion = $null
    $javacVersion = $null
    $mavenVersion = $null
    $gradleVersion = $null
    
    # 检查 java
    try {
        $javaVersion = & java -version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Java: $javaVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Java 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 javac
    try {
        $javacVersion = & javac -version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Javac: $javacVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Javac 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 Maven
    try {
        $mavenVersion = & mvn -version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Maven: $mavenVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Maven 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 Gradle
    try {
        $gradleVersion = & gradle -version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Gradle: $gradleVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Gradle 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

function Check-Python {
    Write-Host ""
    Write-Host "=== Python 环境 ===" -ForegroundColor Cyan
    
    # 检查 python
    try {
        $pythonVersion = & python --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Python: $pythonVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Python 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 python3
    try {
        $python3Version = & python3 --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Python3: $python3Version" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Python3 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 pip
    try {
        $pipVersion = & pip --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Pip: $pipVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Pip 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

function Check-NodeJS {
    Write-Host ""
    Write-Host "=== Node.js 环境 ===" -ForegroundColor Cyan
    
    # 检查 node
    try {
        $nodeVersion = & node --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Node.js: $nodeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Node.js 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 npm
    try {
        $npmVersion = & npm --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ npm: $npmVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ npm 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 yarn
    try {
        $yarnVersion = & yarn --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ yarn: $yarnVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ yarn 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 pnpm
    try {
        $pnpmVersion = & pnpm --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ pnpm: $pnpmVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ pnpm 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

function Check-Docker {
    Write-Host ""
    Write-Host "=== Docker 环境 ===" -ForegroundColor Cyan
    
    # 检查 docker
    try {
        $dockerVersion = & docker --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Docker: $dockerVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Docker 未安装或不在 PATH 中" -ForegroundColor Red
    }
    
    # 检查 docker-compose
    try {
        $composeVersion = & docker-compose --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Docker Compose: $composeVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Docker Compose 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

function Check-Git {
    Write-Host ""
    Write-Host "=== Git 环境 ===" -ForegroundColor Cyan
    
    try {
        $gitVersion = & git --version 2>&1 | Select-Object -First 1
        Write-Host "  ✓ Git: $gitVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Git 未安装或不在 PATH 中" -ForegroundColor Red
    }
}

function Check-System {
    Write-Host ""
    Write-Host "=== 系统信息 ===" -ForegroundColor Cyan
    
    # 操作系统
    $os = Get-SystemInfo -ClassName "Win32_OperatingSystem"
    Write-Host "  操作系统: $($os.Caption) $($os.Version)" -ForegroundColor Gray
    
    # 架构
    $arch = $env:PROCESSOR_ARCHITECTURE
    Write-Host "  架构: $arch" -ForegroundColor Gray
    
    # 磁盘空间
    $drives = Get-SystemInfo -ClassName "Win32_LogicalDisk" | Where-Object { $_.DriveType -eq 3 }
    Write-Host "  磁盘空间:" -ForegroundColor Gray
    foreach ($drive in $drives) {
        $freeGB = [math]::Round($drive.FreeSpace / 1GB, 2)
        $totalGB = [math]::Round($drive.Size / 1GB, 2)
        $usedGB = [math]::Round(($drive.Size - $drive.FreeSpace) / 1GB, 2)
        Write-Host "    $($drive.DeviceID) $usedGB/$totalGB GB (剩余 $freeGB GB)" -ForegroundColor Gray
    }
    
    # 内存
    $memory = Get-SystemInfo -ClassName "Win32_ComputerSystem"
    $totalMemoryGB = [math]::Round($memory.TotalPhysicalMemory / 1GB, 2)
    Write-Host "  内存: $totalMemoryGB GB" -ForegroundColor Gray
}

# 主函数
function Main {
    Write-Host "=== 环境检查工具 ===" -ForegroundColor Cyan
    Write-Host ""
    
    Check-System
    Check-Java
    Check-Python
    Check-NodeJS
    Check-Docker
    Check-Git
    
    Write-Host ""
    Write-Host "=== 检查完成 ===" -ForegroundColor Cyan
}

# 执行
Main
