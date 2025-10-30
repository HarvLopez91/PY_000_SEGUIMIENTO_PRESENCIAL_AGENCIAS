# Clean.ps1 - Script de limpieza para Seguimiento Presencial Agencias

param(
    [switch]$All,
    [switch]$Test,
    [switch]$DryRun
)

Write-Host "🧹 LIMPIEZA - Seguimiento Presencial Agencias" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Green

if ($DryRun) {
    Write-Host "⚠️  MODO DRY RUN - NO SE ELIMINARÁ NADA" -ForegroundColor Yellow
}

# Mostrar versión actual
$Version = & python version_cli.py current 2>$null
if ($Version) {
    Write-Host "📊 Versión del proyecto: $Version" -ForegroundColor Green
} else {
    Write-Host "📊 No se pudo obtener la versión del proyecto" -ForegroundColor Yellow
}

function Remove-Files {
    param([string[]]$Patterns, [string]$Description)
    
    Write-Host "🧹 Limpiando: $Description" -ForegroundColor Yellow
    
    foreach ($Pattern in $Patterns) {
        $Items = Get-ChildItem -Path $Pattern -Recurse -Force -ErrorAction SilentlyContinue
        
        foreach ($Item in $Items) {
            if ($DryRun) {
                Write-Host "  [DRY RUN] Eliminaría: $($Item.Name)" -ForegroundColor Yellow
            } else {
                Remove-Item $Item.FullName -Force -Recurse -ErrorAction SilentlyContinue
                Write-Host "  ✅ Eliminado: $($Item.Name)" -ForegroundColor Green
            }
        }
    }
}

# Limpieza de artefactos de testing
if ($All -or $Test) {
    Write-Host "`n=== LIMPIEZA DE ARTEFACTOS DE TESTING ===" -ForegroundColor Cyan
    
    $TestPatterns = @(
        "__pycache__",
        "*.pyc",
        ".pytest_cache",
        "htmlcov",
        ".coverage"
    )
    
    Remove-Files -Patterns $TestPatterns -Description "Artefactos de testing"
}

# Limpieza completa
if ($All) {
    Write-Host "`n=== LIMPIEZA COMPLETA ===" -ForegroundColor Cyan
    
    $AllPatterns = @(
        "*.tmp",
        "*.bak", 
        "*~",
        "*.log",
        "tmp\*"
    )
    
    Remove-Files -Patterns $AllPatterns -Description "Archivos temporales y logs"
}

Write-Host "`n✅ LIMPIEZA COMPLETADA" -ForegroundColor Green

if ($DryRun) {
    Write-Host "💡 Para ejecutar la limpieza real, remover el parámetro -DryRun" -ForegroundColor Yellow
}

if (-not ($All -or $Test)) {
    Write-Host "`nUSO:" -ForegroundColor Yellow
    Write-Host "  .\Clean.ps1 -Test     # Limpiar artefactos de testing"
    Write-Host "  .\Clean.ps1 -All      # Limpieza completa"
    Write-Host "  .\Clean.ps1 -All -DryRun  # Ver qué se eliminaría"
}