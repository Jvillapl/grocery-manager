#!/bin/bash
# Script para configurar el repositorio remoto de GitHub
# Uso: .\setup-github.ps1 TU_USUARIO_GITHUB

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername
)

Write-Host "🚀 Configurando repositorio remoto para: $GitHubUsername" -ForegroundColor Green

# Verificar que estamos en un repositorio git
if (-not (Test-Path ".git")) {
    Write-Host "❌ Error: No estás en un repositorio Git" -ForegroundColor Red
    exit 1
}

# Configurar repositorio remoto
$repoUrl = "https://github.com/$GitHubUsername/grocery-manager.git"
Write-Host "📡 Añadiendo repositorio remoto: $repoUrl" -ForegroundColor Yellow

try {
    # Añadir remote origin
    git remote add origin $repoUrl
    Write-Host "✅ Repositorio remoto añadido" -ForegroundColor Green
    
    # Cambiar a rama main
    git branch -M main
    Write-Host "✅ Rama cambiada a 'main'" -ForegroundColor Green
    
    # Mostrar status
    Write-Host "`n📋 Estado actual:" -ForegroundColor Cyan
    git remote -v
    git branch
    
    Write-Host "`n🎯 Próximo paso:" -ForegroundColor Cyan
    Write-Host "1. Ve a https://github.com/new" -ForegroundColor White
    Write-Host "2. Crear repositorio: 'grocery-manager'" -ForegroundColor White
    Write-Host "3. Ejecutar: git push -u origin main" -ForegroundColor White
    
} catch {
    Write-Host "❌ Error configurando repositorio: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 Configuración completada!" -ForegroundColor Green