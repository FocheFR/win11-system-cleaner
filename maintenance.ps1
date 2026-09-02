<#
.SYNOPSIS
    Script de nettoyage et d'entretien rapide pour Windows 11.
.DESCRIPTION
    Purge les dossiers temporaires (utilisateur et système), vide la corbeille
    silencieusement et réinitialise le cache DNS.
.NOTES
    Nécessite des privilèges Administrateur.
#>

#Requires -RunAsAdministrator

[CmdletBinding()]
param()

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorActionPreference = 'SilentlyContinue'

Write-Host "=== Démarrage de la maintenance système ===" -ForegroundColor Cyan

# 1. Vérification des droits administrateur (redondance propre)
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Ce script doit être exécuté dans un terminal PowerShell Administrateur."
    exit 1
}

# 2. Nettoyage du dossier temporaire utilisateur ($env:TEMP)
Write-Host "[+] Nettoyage des fichiers temporaires utilisateur..." -NoNewline
$userTemp = $env:TEMP
if (Test-Path $userTemp) {
    Get-ChildItem -Path $userTemp -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host " [OK]" -ForegroundColor Green
} else {
    Write-Host " [Introuvable]" -ForegroundColor Yellow
}

# 3. Nettoyage du dossier temporaire système (C:\Windows\Temp)
Write-Host "[+] Nettoyage des fichiers temporaires système..." -NoNewline
$sysTemp = "$env:SystemRoot\Temp"
if (Test-Path $sysTemp) {
    Get-ChildItem -Path $sysTemp -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host " [OK]" -ForegroundColor Green
} else {
    Write-Host " [Introuvable]" -ForegroundColor Yellow
}

# 4. Vidage de la corbeille sur tous les disques
Write-Host "[+] Vidage de la corbeille..." -NoNewline
try {
    Clear-RecycleBin -Force -ErrorAction Stop
    Write-Host " [OK]" -ForegroundColor Green
} catch {
    Write-Host " [Déjà vide ou inaccessible]" -ForegroundColor Yellow
}

# 5. Vidage du cache de résolution DNS
Write-Host "[+] Vidage du cache DNS..." -NoNewline
try {
    Clear-DnsClientCache -ErrorAction Stop
    Write-Host " [OK]" -ForegroundColor Green
} catch {
    Write-Host " [Erreur]" -ForegroundColor Red
}

Write-Host "`nMaintenance terminée avec succès." -ForegroundColor Cyan