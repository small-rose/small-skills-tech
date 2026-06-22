# verify-url.ps1
# URL 验证脚本

param(
    [Parameter(Mandatory=$false)]
    [string]$Url,
    
    [Parameter(Mandatory=$false)]
    [string]$UrlList,
    
    [Parameter(Mandatory=$false)]
    [int]$Timeout = 10
)

function Test-Url {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 10
    )
    
    $result = @{
        Url = $Url
        Status = "Unknown"
        StatusCode = $null
        Error = $null
        ResponseTime = $null
    }
    
    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        
        $response = Invoke-WebRequest -Uri $Url -Method Head -TimeoutSec $TimeoutSeconds -UseBasicParsing -ErrorAction Stop
        
        $stopwatch.Stop()
        
        $result.Status = "Success"
        $result.StatusCode = $response.StatusCode
        $result.ResponseTime = $stopwatch.ElapsedMilliseconds
    }
    catch {
        $result.Status = "Failed"
        $result.Error = $_.Exception.Message
        
        if ($_.Exception.Response) {
            $result.StatusCode = [int]$_.Exception.Response.StatusCode
        }
    }
    
    return $result
}

function Main {
    Write-Host "=== URL 验证工具 ===" -ForegroundColor Cyan
    
    $urls = @()
    
    if ($Url) {
        $urls += $Url
    }
    
    if ($UrlList) {
        if (Test-Path $UrlList) {
            $urls += Get-Content $UrlList | Where-Object { $_ -match "^https?://" }
        }
        else {
            Write-Host "错误: URL 列表文件不存在: $UrlList" -ForegroundColor Red
            return
        }
    }
    
    if ($urls.Count -eq 0) {
        Write-Host "请提供要验证的 URL" -ForegroundColor Yellow
        Write-Host "用法: .\verify-url.ps1 -Url 'https://example.com'" -ForegroundColor Gray
        Write-Host "用法: .\verify-url.ps1 -UrlList 'urls.txt'" -ForegroundColor Gray
        return
    }
    
    Write-Host ""
    Write-Host "=== 验证结果 ===" -ForegroundColor Cyan
    
    $successCount = 0
    $failCount = 0
    
    foreach ($url in $urls) {
        $result = Test-Url -Url $url -TimeoutSeconds $Timeout
        
        if ($result.Status -eq "Success") {
            Write-Host "  ✓ $($result.Url) - $($result.StatusCode) ($($result.ResponseTime)ms)" -ForegroundColor Green
            $successCount++
        }
        else {
            Write-Host "  ✗ $($result.Url) - $($result.Error)" -ForegroundColor Red
            $failCount++
        }
    }
    
    Write-Host ""
    Write-Host "=== 统计 ===" -ForegroundColor Cyan
    Write-Host "总数: $($urls.Count)" -ForegroundColor Gray
    Write-Host "成功: $successCount" -ForegroundColor Green
    Write-Host "失败: $failCount" -ForegroundColor Red
}

# 执行
Main
