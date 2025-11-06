# Script de verificación y deployment
param(
    [string]$Action = "help"
)

$SERVICE_NAME = "holaflask"
$IMAGE_NAME = "holaflask"
$REGISTRY = "ghcr.io"

switch ($Action) {
    "check" {
        Write-Host "Verificando archivos..." -ForegroundColor Yellow
        $files = @("app.py", "Dockerfile", "requirements.txt", ".gitignore", ".dockerignore")
        foreach ($file in $files) {
            if (Test-Path $file) {
                Write-Host "[OK] $file" -ForegroundColor Green
            } else {
                Write-Host "[ERROR] Falta $file" -ForegroundColor Red
            }
        }
        Write-Host "Verificacion completa!" -ForegroundColor Cyan
    }
    "build" {
        Write-Host "Construyendo imagen Docker..." -ForegroundColor Yellow
        docker build -t $IMAGE_NAME .
    }
    "run" {
        Write-Host "Ejecutando contenedor..." -ForegroundColor Yellow
        docker run -d -p 5000:5000 --name $SERVICE_NAME $IMAGE_NAME
        Write-Host "Contenedor iniciado. Prueba: http://localhost:5000" -ForegroundColor Green
    }
    "start" {
        Write-Host "Iniciando todo desde cero..." -ForegroundColor Yellow
        & $PSCommandPath -Action build
        & $PSCommandPath -Action run
    }
    "logs" {
        docker logs -f $SERVICE_NAME
    }
    "status" {
        docker ps -a --filter "name=$SERVICE_NAME"
    }
    "test" {
        Write-Host "Probando el contenedor..." -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing
            Write-Host "[OK] El contenedor responde correctamente!" -ForegroundColor Green
            Write-Host "Respuesta: $($response.Content)" -ForegroundColor Cyan
        } catch {
            Write-Host "[ERROR] El contenedor no responde" -ForegroundColor Red
        }
    }
    "stop" {
        Write-Host "Deteniendo contenedor..." -ForegroundColor Yellow
        docker stop $SERVICE_NAME
    }
    "rm" {
        Write-Host "Eliminando contenedor..." -ForegroundColor Yellow
        docker rm $SERVICE_NAME
    }
    "down" {
        & $PSCommandPath -Action stop
        & $PSCommandPath -Action rm
    }
    "rebuild" {
        Write-Host "Reconstruyendo todo..." -ForegroundColor Yellow
        docker stop $SERVICE_NAME 2>$null
        docker rm $SERVICE_NAME 2>$null
        docker build -t $IMAGE_NAME .
        docker run -d -p 5000:5000 --name $SERVICE_NAME $IMAGE_NAME
        Write-Host "Reconstruccion completa!" -ForegroundColor Green
    }
    "clean" {
        Write-Host "Limpiando imagenes huerfanas..." -ForegroundColor Yellow
        docker system prune -f
    }
    "publish" {
        Write-Host "Publicando en GHCR..." -ForegroundColor Yellow
        docker buildx build --platform linux/amd64,linux/arm64 -t "$REGISTRY/${IMAGE_NAME}:latest" . --push
    }
    "help" {
        Write-Host "Comandos disponibles:" -ForegroundColor Cyan
        Write-Host "  .\run.ps1 check      - Verificar archivos" -ForegroundColor White
        Write-Host "  .\run.ps1 build      - Construir imagen Docker" -ForegroundColor White
        Write-Host "  .\run.ps1 run        - Ejecutar contenedor" -ForegroundColor White
        Write-Host "  .\run.ps1 start      - Build + Run en un comando" -ForegroundColor White
        Write-Host "  .\run.ps1 logs       - Ver logs del contenedor" -ForegroundColor White
        Write-Host "  .\run.ps1 status     - Ver estado del contenedor" -ForegroundColor White
        Write-Host "  .\run.ps1 test       - Probar que funciona" -ForegroundColor White
        Write-Host "  .\run.ps1 stop       - Detener contenedor" -ForegroundColor White
        Write-Host "  .\run.ps1 down       - Detener + Eliminar contenedor" -ForegroundColor White
        Write-Host "  .\run.ps1 rebuild    - Reconstruir todo" -ForegroundColor White
        Write-Host "  .\run.ps1 clean      - Limpiar imagenes huerfanas" -ForegroundColor White
        Write-Host "  .\run.ps1 publish    - Publicar en GHCR" -ForegroundColor White
    }
    default {
        Write-Host "Comando no reconocido. Usa '.\run.ps1 help' para ver los comandos disponibles." -ForegroundColor Red
    }
}
