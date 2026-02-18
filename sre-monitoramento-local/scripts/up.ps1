Write-Host "Subindo stack de monitoramento..." -ForegroundColor Green
docker compose up -d --build
Write-Host ""
Write-Host "Containers rodando:" -ForegroundColor Cyan
docker compose ps
Write-Host ""
Write-Host "Endpoints disponiveis:" -ForegroundColor Yellow
Write-Host "  App:        http://localhost:8080"
Write-Host "  Prometheus: http://localhost:9090"
Write-Host "  Grafana:    http://localhost:3000 (admin/admin)"