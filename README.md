# Windows 11 System Cleaner

Script PowerShell léger d'automatisation pour la maintenance basique de Windows 11.

## Fonctionnalités

- **Vérification automatique des privilèges** : empêche l'exécution sans droits administrateur.
- **Purge des répertoires temporaires** : supprime les fichiers résiduels dans `%TEMP%` et `C:\Windows\Temp` sans bloquer sur les fichiers verrouillés.
- **Vidage de la corbeille** : nettoyage forcé et silencieux sur tous les lecteurs montés.
- **Cache réseau** : réinitialisation complète du cache du résolveur DNS (`Clear-DnsClientCache`).

## Utilisation

Ouvre un terminal **PowerShell en Administrateur** et exécute :

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\maintenance.ps1
```

## Licence

Distribué sous licence MIT.
