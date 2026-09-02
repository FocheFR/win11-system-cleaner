<#
.SYNOPSIS
    Interface graphique de nettoyage pour Windows 11.
#>

#Requires -RunAsAdministrator

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Cleaner"
$form.Size = New-Object System.Drawing.Size(430, 480)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# 1. Options à cocher
$chkUserTemp = New-Object System.Windows.Forms.CheckBox
$chkUserTemp.Text = "Fichiers temporaires utilisateur (%TEMP%)"
$chkUserTemp.Location = New-Object System.Drawing.Point(25, 20)
$chkUserTemp.Size = New-Object System.Drawing.Size(360, 24)
$chkUserTemp.Checked = $true
$form.Controls.Add($chkUserTemp)

$chkSysTemp = New-Object System.Windows.Forms.CheckBox
$chkSysTemp.Text = "Fichiers temporaires système (C:\Windows\Temp)"
$chkSysTemp.Location = New-Object System.Drawing.Point(25, 50)
$chkSysTemp.Size = New-Object System.Drawing.Size(360, 24)
$chkSysTemp.Checked = $true
$form.Controls.Add($chkSysTemp)

$chkRecycle = New-Object System.Windows.Forms.CheckBox
$chkRecycle.Text = "Vider la corbeille"
$chkRecycle.Location = New-Object System.Drawing.Point(25, 80)
$chkRecycle.Size = New-Object System.Drawing.Size(360, 24)
$chkRecycle.Checked = $true
$form.Controls.Add($chkRecycle)

$chkDns = New-Object System.Windows.Forms.CheckBox
$chkDns.Text = "Vider le cache DNS"
$chkDns.Location = New-Object System.Drawing.Point(25, 110)
$chkDns.Size = New-Object System.Drawing.Size(360, 24)
$chkDns.Checked = $true
$form.Controls.Add($chkDns)

# 2. Bouton d'action
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Lancer le nettoyage"
$btnRun.Location = New-Object System.Drawing.Point(25, 150)
$btnRun.Size = New-Object System.Drawing.Size(365, 35)
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnRun)

# 3. Zone de logs
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ReadOnly = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.Location = New-Object System.Drawing.Point(25, 200)
$txtLog.Size = New-Object System.Drawing.Size(365, 220)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 8.5)
$form.Controls.Add($txtLog)

# Fonction d'écriture dans le journal
function Write-Log ($text) {
    $txtLog.AppendText("$text`r`n")
    $txtLog.ScrollToCaret()
    $form.Refresh()
}

# 4. Exécution au clic
$btnRun.Add_Click({
    $btnRun.Enabled = $false
    $txtLog.Clear()
    Write-Log "=== Début du nettoyage ==="

    if ($chkUserTemp.Checked) {
        Write-Log "[*] Nettoyage temp utilisateur..."
        if (Test-Path $env:TEMP) {
            Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "    -> Terminé."
        }
    }

    if ($chkSysTemp.Checked) {
        Write-Log "[*] Nettoyage temp système..."
        $sysTemp = "$env:SystemRoot\Temp"
        if (Test-Path $sysTemp) {
            Get-ChildItem -Path $sysTemp -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "    -> Terminé."
        }
    }

    if ($chkRecycle.Checked) {
        Write-Log "[*] Vidage de la corbeille..."
        try {
            Clear-RecycleBin -Force -ErrorAction Stop
            Write-Log "    -> Corbeille vidée."
        } catch {
            Write-Log "    -> Déjà vide ou inaccessible."
        }
    }

    if ($chkDns.Checked) {
        Write-Log "[*] Vidage du cache DNS..."
        try {
            Clear-DnsClientCache -ErrorAction Stop
            Write-Log "    -> Cache DNS purgé."
        } catch {
            Write-Log "    -> Échec du vidage DNS."
        }
    }

    Write-Log "`n=== Nettoyage terminé ==="
    $btnRun.Enabled = $true
})

# Affichage de la fenêtre
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()