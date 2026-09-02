# Windows 11 System Cleaner

Outil d'automatisation léger et modulaire pour l'entretien rapide de Windows 11. Conçu pour purger les fichiers résiduels et réinitialiser le cache réseau sans installer de logiciels tiers encombrants.

Disponible au choix en **version console automatisée** (`maintenance.ps1`) ou en **application graphique avec sélection à la carte** (`cleaner-gui.ps1`).

---

## Fonctionnalités

* **Contrôle d'accès** : vérifie et impose l'exécution avec les privilèges Administrateur.
* **Sélection à la carte (Mode GUI)** :
  * Fichiers temporaires utilisateur (`%TEMP%`)
  * Fichiers temporaires système (`C:\Windows\Temp`)
  * Vidage complet de la corbeille sur l'ensemble des lecteurs montés
  * Réinitialisation du cache de résolution DNS local (`Clear-DnsClientCache`)
* **Résilience** : contourne silencieusement les fichiers verrouillés par les processus en cours d'exécution sans interrompre le script.
* **Journalisation en direct** : affichage du statut de chaque tâche en temps réel.
* **Portabilité** : transformable en exécutable binaire `.exe` autonome.

---

## Structure du dépôt

```text
win11-system-cleaner/
├── .gitignore
├── LICENSE
├── README.md
├── maintenance.ps1      # Script CLI rapide (tout-en-un)
└── cleaner-gui.ps1      # Interface graphique WinForms avec options
```

---

## Prérequis

* Windows 10 ou Windows 11
* PowerShell 5.1 ou PowerShell 7+
* Droits Administrateur

---

## Utilisation

Ouvre un terminal **PowerShell en mode Administrateur** dans le répertoire du projet.

### Option 1 — Application graphique (Recommandé)

Lance l'interface interactive pour cocher les éléments à nettoyer :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\cleaner-gui.ps1
```

### Option 2 — Nettoyage rapide en console

Exécute la routine complète directement dans le terminal :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\maintenance.ps1
```

---

## Compiler en exécutable (.exe)

Pour lancer l'application d'un simple double-clic sans afficher de console PowerShell en arrière-plan, compile le script GUI avec `ps2exe` :

```powershell
# 1. Installer le module de compilation (une seule fois)
Install-Module -Name ps2exe -Scope CurrentUser -Force

# 2. Générer le fichier exécutable
Invoke-PS2EXE -InputFile .\cleaner-gui.ps1 -OutputFile .\WindowsCleaner.exe -noConsole -requireAdmin -title "Windows 11 Cleaner"
```

Le fichier `WindowsCleaner.exe` demandera automatiquement l'élévation UAC au démarrage.

---

## Téléchargement direct

Tu peux télécharger directement l'exécutable autonome (sans passer par la console) sur la page des [Releases](https://github.com/FocheFR/win11-system-cleaner/releases).

## Licence

Distribué sous licence MIT. Consulte le fichier `LICENSE` pour plus de détails.
