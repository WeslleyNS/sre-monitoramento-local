Write-Host "=== Status dos Containers ===" -ForegroundColor Cyan
docker compose ps
Write-Host ""

Write-Host "=== Health dos Endpoints ===" -ForegroundColor Cyan

# App
try {
    $app = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://localhost:8080/health
    Write-Host "[OK] App:        http://localhost:8080/health - Status: $($app.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] App:      http://localhost:8080/health - Erro" -ForegroundColor Red
}

# Prometheus
try {
    $prom = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://localhost:9090/-/healthy
    Write-Host "[OK] Prometheus: http://localhost:9090/-/healthy - Status: $($prom.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Prometheus: http://localhost:9090/-/healthy - Erro" -ForegroundColor Red
}

# Grafana
try {
    $grafana = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://localhost:3000/api/health
    Write-Host "[OK] Grafana:    http://localhost:3000/api/health - Status: $($grafana.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Grafana:  http://localhost:3000/api/health - Erro" -ForegroundColor Red
}