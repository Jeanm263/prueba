# Script para subir a Git
param(
    [string]$mensaje = "Update proyecto Flask"
)

Write-Host "Preparando para subir a Git..." -ForegroundColor Cyan

# Git add
Write-Host "Agregando archivos..." -ForegroundColor Yellow
git add app.py
git add Dockerfile
git add requirements.txt
git add .gitignore
git add .dockerignore
git add Makefile
git add run.ps1

# Git status
Write-Host "`nEstado de Git:" -ForegroundColor Yellow
git status

# Git commit
Write-Host "`nCreando commit..." -ForegroundColor Yellow
git commit -m $mensaje

# Git push
Write-Host "`nSubiendo a repositorio remoto..." -ForegroundColor Yellow
git push

Write-Host "`n[OK] Proyecto subido exitosamente!" -ForegroundColor Green
