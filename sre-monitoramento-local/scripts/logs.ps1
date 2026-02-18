param(
    [string]$service = "app"
)

Write-Host "Logs do servico: $service" -ForegroundColor Cyan
docker compose logs -f --tail 100 $service