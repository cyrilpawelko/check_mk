# Pygram Cyril
# Based on http://andrewmorgan.ie/2012/12/05/viewing-open-files-on-a-file-server-from-powershell/

function get-openfiles{
param(
    $computername=@($env:computername),
    $verbose=$false)
    $collection = @()
foreach ($computer in $computername){
    $netfile = [ADSI]"WinNT://$computer/LanmanServer"
 
        $netfile.Invoke("Resources") | foreach {
            try{
                $collection += New-Object PsObject -Property @{
                  Id = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
                  itemPath = $_.GetType().InvokeMember("Path", 'GetProperty', $null, $_, $null)
                  UserName = $_.GetType().InvokeMember("User", 'GetProperty', $null, $_, $null)
                  LockCount = $_.GetType().InvokeMember("LockCount", 'GetProperty', $null, $_, $null)
                  Server = $computer
                }
            }
            catch{
                if ($verbose){write-warning $error[0]}
            }
        }
    }
    Return $collection
}

$fichiers = get-openfiles

# Fichiers ouverts: 
$nb_fichiers_ouverts = $fichiers.count

# Fichiers verrouillées : 
$nb_fichiers_verrouilles = ($fichiers | ? {$_.lockcount -gt 0 } |measure  ).count

# Fichiers .INI ouverts: 
$nb_fichiers_ini_ouverts =($fichiers | ? {$_.itempath -like "*desktop.ini"} | measure ).Count

# Fichiers .INI verrouillés: 
$nb_fichiers_ini_verrouilles =($fichiers | ? {$_.itempath -like "*desktop.ini" -and $_.lockcount -gt 0} | measure ).Count

$message = "$nb_fichiers_ouverts fichiers ouverts dont $nb_fichiers_verrouilles verrouilles. $nb_fichiers_ini_ouverts fichiers desktop.ini ouverts dont $nb_fichiers_ini_verrouilles verrouilles"

write-host "0 Fichiers_ouverts nb_fichiers_ouverts=$nb_fichiers_ouverts|nb_fichiers_verrouilles=$nb_fichiers_verrouilles|nb_fichiers_ini_ouverts=$nb_fichiers_ini_ouverts|nb_fichiers_ini_verrouilles=$nb_fichiers_ini_verrouilles $message"