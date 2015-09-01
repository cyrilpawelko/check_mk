# Cyril - Pygram - 09/04/2014
# Adapté de http://www.wsus.de/cgi-bin/yabb/YaBB.pl?num=1253864650

# Variables - set these to fit your needs
###############################################################################
# The server name of your WSUS server
$serverName = 'localhost'

# use SSL connection?
$useSecureConnection = $False

# the port number of your WSUS IIS website
$portNumber = 8530

# warn if a computer has not contacted the server for ... days
$daysBeforeWarn = 14



# Script - don't change anything below this line!
###############################################################################

# load WSUS framework
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")   

# connect to specified WSUS server
# see here for information of the IUpdateServer class
# -> http://msdn.microsoft.com/en-us/library/microsoft.updateservices.administration.iupdateserver(VS.85).aspx
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($serverName, $useSecureConnection, $portNumber)   

# get general status information
# see here for more infos about the properties of GetStatus()
# -> http://msdn.microsoft.com/en-us/library/microsoft.updateservices.administration.updateserverstatus_properties(VS.85).aspx
$status = $wsus.GetStatus()
$totalComputers = $status.ComputerTargetCount
$computersUpToDate = $status.ComputersUpToDateCount
$computersNeedingUpdates = $status.ComputerTargetsNeedingUpdatesCount
$computersWithErrors = $status.ComputerTargetsWithUpdateErrorsCount
$totalUpdates = $status.UpdateCount
$updatesUpToDate = $status.UpdatesUpToDateCount
$updatesNeeded = $status.UpdatesNeededByComputersCount
$updatesWithErrors = $status.UpdatesWithClientErrorsCount

# needed, but not approved updates
$updateScope = new-object Microsoft.UpdateServices.Administration.UpdateScope
$updateScope.ApprovedStates = [Microsoft.UpdateServices.Administration.ApprovedStates]::NotApproved
$updateServerStatus = $wsus.GetUpdateStatus($updateScope, $False)
$updatesNeededByComputersNotApproved = $updateServerStatus.UpdatesNeededByComputersCount

# computers that did not contact the server in $daysBeforeWarn days
$timeSpan = new-object TimeSpan($daysBeforeWarn, 0, 0, 0)
$computersNotContacted = $wsus.GetComputersNotContactedSinceCount([DateTime]::UtcNow.Subtract($timeSpan))

# computers in the "not assigned" group
$computerTargetScope = new-object Microsoft.UpdateServices.Administration.ComputerTargetScope
$computersNotAssigned = $wsus.GetComputerTargetGroup([Microsoft.UpdateServices.Administration.ComputerTargetGroupId]::UnassignedComputers).GetComputerTargets().Count

<#
# output
"WSUS statistics"
"--------------------------------------------------"
"Total Computers:                  $totalComputers"
"Computers up to date:                  $computersUpToDate"
"Computers needing updates:            $computersNeedingUpdates"
"Computers with errors:                  $computersWithErrors"
"--------------------------------------------------"
"Total Updates:                        $totalUpdates"
"Updates up to date:                  $updatesUpToDate"
"Updates needed by computers:            $updatesNeeded"
"Updates with errors:                  $updatesWithErrors"
"--------------------------------------------------"
"Updates that need to be approved:      $updatesNeededByComputersNotApproved"
"Computers not contacted in $daysBeforeWarn days:      $computersNotContacted"
"Unassigned computers:                  $computersNotAssigned" 
#>

"0 WSUS_Computers wsus_computers_total=$totalComputers|wsus_computers_uptodate=$computersUpToDate|wsus_computers_needsupdate=$computersNeedingUpdates|wsus_computers_inerror=$computersWithErrors WSUS $totalComputers ordinateurs, $computersUpToDate a jour, $computersNeedingUpdates a mettre a jour, $computersWithErrors en erreur"
"0 WSUS_Updates wsus_updates_total=$totalUpdates|wsus_updates_uptodate=$updatesUpToDate|wsus_updates_needed=$updatesNeeded|wsus_updates_error=$updatesWithErrors|wsus_updates_needednotapproved=$updatesNeededByComputersNotApproved WSUS $totalUpdates mises a jour, $updatesUpToDate a jour, $updatesNeeded necessaires, $updatesWithErrors en erreur,  $updatesNeededByComputersNotApproved necessaires et non approuvees"