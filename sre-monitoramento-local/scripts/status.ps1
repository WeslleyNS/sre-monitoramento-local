function Check-Service {
    param($container, $name, $url)
    $status = docker inspect -f '{{.State.Status}}' $container 2>$null
    if ($status -eq "running") {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
            if ($response.StatusCode -eq 200) {
                Write-Host "[OK] ${name}: " -NoNewline -ForegroundColor Green
                Write-Host "$url - Status: $($response.StatusCode)" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "[ERRO] ${name}: $url não respondeu" -ForegroundColor Red
        }
    } else {
        Write-Host "[ERRO] ${name}: container não está rodando" -ForegroundColor Red
    }
}

Write-Host "`n=== Status dos Containers ===" -ForegroundColor Yellow
docker compose ps

Write-Host "`n=== Health dos Endpoints ===" -ForegroundColor Yellow
Check-Service "sre_app" "App" "http://localhost:8080/health"
Check-Service "sre_victoriametrics" "VictoriaMetrics" "http://localhost:8428/health"
Check-Service "sre_grafana" "Grafana" "http://localhost:3000/api/health"
Check-Service "sre_alertmanager" "Alertmanager" "http://localhost:9093/-/healthy"

Write-Host ""