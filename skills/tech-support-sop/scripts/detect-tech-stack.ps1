# detect-tech-stack.ps1
# 技术栈检测脚本

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = "."
)

function Detect-TechStack {
    param(
        [string]$Path
    )
    
    $result = @{
        Java = $false
        Python = $false
        NodeJS = $false
        Docker = $false
        Nginx = $false
        Details = @()
    }
    
    # 检查 Java
    if (Test-Path "$Path\pom.xml") {
        $result.Java = $true
        $result.Details += "发现 Maven 项目 (pom.xml)"
    }
    if (Test-Path "$Path\build.gradle") {
        $result.Java = $true
        $result.Details += "发现 Gradle 项目 (build.gradle)"
    }
    
    # 检查 Python
    if (Test-Path "$Path\requirements.txt") {
        $result.Python = $true
        $result.Details += "发现 Python 项目 (requirements.txt)"
    }
    if (Test-Path "$Path\pyproject.toml") {
        $result.Python = $true
        $result.Details += "发现 Python 项目 (pyproject.toml)"
    }
    if (Test-Path "$Path\setup.py") {
        $result.Python = $true
        $result.Details += "发现 Python 项目 (setup.py)"
    }
    
    # 检查 Node.js
    if (Test-Path "$Path\package.json") {
        $result.NodeJS = $true
        $result.Details += "发现 Node.js 项目 (package.json)"
    }
    
    # 检查 Docker
    if (Test-Path "$Path\Dockerfile") {
        $result.Docker = $true
        $result.Details += "发现 Dockerfile"
    }
    if (Test-Path "$Path\docker-compose.yml") {
        $result.Docker = $true
        $result.Details += "发现 docker-compose.yml"
    }
    if (Test-Path "$Path\docker-compose.yaml") {
        $result.Docker = $true
        $result.Details += "发现 docker-compose.yaml"
    }
    
    # 检查 Nginx
    if (Test-Path "$Path\nginx.conf") {
        $result.Nginx = $true
        $result.Details += "发现 nginx.conf"
    }
    
    return $result
}

# 主函数
function Main {
    Write-Host "=== 技术栈检测 ===" -ForegroundColor Cyan
    Write-Host "检测路径: $ProjectPath" -ForegroundColor Gray
    
    $result = Detect-TechStack -Path $ProjectPath
    
    Write-Host ""
    Write-Host "=== 检测结果 ===" -ForegroundColor Cyan
    
    if ($result.Details.Count -eq 0) {
        Write-Host "未检测到已知的技术栈" -ForegroundColor Yellow
    }
    else {
        foreach ($detail in $result.Details) {
            Write-Host "  ✓ $detail" -ForegroundColor Green
        }
    }
    
    Write-Host ""
    Write-Host "=== 技术栈汇总 ===" -ForegroundColor Cyan
    
    $stacks = @()
    if ($result.Java) { $stacks += "Java" }
    if ($result.Python) { $stacks += "Python" }
    if ($result.NodeJS) { $stacks += "Node.js" }
    if ($result.Docker) { $stacks += "Docker" }
    if ($result.Nginx) { $stacks += "Nginx" }
    
    if ($stacks.Count -eq 0) {
        Write-Host "未检测到技术栈" -ForegroundColor Yellow
    }
    else {
        Write-Host "检测到的技术栈: $($stacks -join ', ')" -ForegroundColor Green
    }
    
    return $result
}

# 执行
Main
