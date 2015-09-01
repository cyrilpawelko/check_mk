# check_mk local rdp_sessions
# v0.1
# cyril 18/07/2013
# valide sur windows 2008 r0

$warning = 41
$critical = 46
$actif = @(query session | ?{ $_ -match 'Actif' }).count
$deco = @(query session | ?{ ($_ -match 'Déco') -and !($_ -match 'services') }).count
$somme = $actif + $deco
$etat = 0 # OK
if ($somme -ge $warning) { 
    $etat = 1 # Warning
    } 
if ($somme -ge $critical) { $etat = 1 } # Critical
echo "$etat rdp_sessions total=$somme;$warning;$critical|actif=$actif|deconnecte=$deco $somme sessions TSE"

