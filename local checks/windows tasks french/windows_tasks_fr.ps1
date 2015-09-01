# Pygram - Cyril - 09/04/2014 - Traduction de la sortie de schtasks en français
# Basé sur check_mk 1.2.4 - 
# Validé en Windows 2003 32 bits + Powerhsell 2.0
# Validé en Windows 2008 R2
echo "<<<windows_tasks:sep(58)>>>"
$tasks = schtasks /query /fo csv -v
$tasks = $tasks -replace "Nom de la tâche","TaskName"
$tasks = $tasks -replace "Nom de l'hôte","HostName"
$tasks = $tasks -replace "Heure de la dernière exécution","Last Run Time"
$tasks = $tasks -replace "Prochaine exécution","Next Run Time"
$tasks = $tasks -replace "Dernier résultat","Last Result"
$tasks = $tasks -replace "Statut de la tâche planifiée","Scheduled Task State"
$tasks = $tasks -replace "Désactivée","Disabled"
$tasks = $tasks -replace "Activée","Enabled"

$tasks | ConvertFrom-Csv  | ? {$_.HostName -match "^$($Env:Computername)$" -and $_.taskname -notlike '\Microsoft*'} | fl taskname,"last run time","next run time","last result","scheduled task state"
