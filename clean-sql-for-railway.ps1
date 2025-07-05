# Script de nettoyage SQL pour Railway MySQL
# Ce script prepare votre fichier SQL local pour l'import sur Railway

param(
    [string]$InputFile = "vue_psg_complete.sql",
    [string]$OutputFile = "vue_psg_railway.sql"
)

Write-Host "🧹 Nettoyage du fichier SQL pour Railway..." -ForegroundColor Yellow

if (-not (Test-Path $InputFile)) {
    Write-Host "❌ Erreur: Le fichier $InputFile n'existe pas!" -ForegroundColor Red
    exit 1
}

try {
    # Lecture du fichier original
    $content = Get-Content $InputFile -Raw -Encoding UTF8
    
    Write-Host "📖 Lecture du fichier $InputFile..." -ForegroundColor Green
    
    # Nettoyage des commandes problématiques
    $content = $content -replace "SET SQL_MODE = `"NO_AUTO_VALUE_ON_ZERO`";", ""
    $content = $content -replace "START TRANSACTION;", ""
    $content = $content -replace "SET time_zone = `"\+00:00`";", ""
    $content = $content -replace "COMMIT;", ""
    
    # Suppression des commentaires phpMyAdmin
    $content = $content -replace "-- phpMyAdmin SQL Dump.*?\n", ""
    $content = $content -replace "-- version.*?\n", ""
    $content = $content -replace "-- https://www.phpmyadmin.net/.*?\n", ""
    $content = $content -replace "-- Hôte :.*?\n", ""
    $content = $content -replace "-- Généré le :.*?\n", ""
    $content = $content -replace "-- Version du serveur :.*?\n", ""
    $content = $content -replace "-- Version de PHP :.*?\n", ""
    
    # Suppression des lignes vides multiples
    $content = $content -replace "`n`n+", "`n`n"
    
    # Création du contenu nettoyé avec les bonnes options
    $cleanContent = @"
-- Fichier SQL nettoyé pour Railway MySQL
-- Généré automatiquement le $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS=0;

$content

SET FOREIGN_KEY_CHECKS=1;
"@

    # Écriture du fichier de sortie
    $cleanContent | Out-File -FilePath $OutputFile -Encoding UTF8 -NoNewline
    
    $originalSize = (Get-Item $InputFile).Length
    $cleanSize = (Get-Item $OutputFile).Length
    
    Write-Host "✅ Fichier nettoyé créé avec succès!" -ForegroundColor Green
    Write-Host "📁 Fichier original: $InputFile ($([math]::Round($originalSize/1KB, 2)) KB)" -ForegroundColor Cyan
    Write-Host "📁 Fichier nettoyé: $OutputFile ($([math]::Round($cleanSize/1KB, 2)) KB)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🚀 Étapes suivantes:" -ForegroundColor Yellow
    Write-Host "1. Connectez-vous à Railway: https://railway.app" -ForegroundColor White
    Write-Host "2. Allez dans votre projet FcManager → Service MySQL" -ForegroundColor White
    Write-Host "3. Utilisez l'onglet 'Data' ou 'Query Editor'" -ForegroundColor White
    Write-Host "4. Importez le fichier: $OutputFile" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Ou copiez le contenu du fichier et collez-le dans l'interface Railway." -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Erreur lors du nettoyage: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
