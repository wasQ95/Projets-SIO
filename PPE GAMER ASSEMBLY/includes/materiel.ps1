
$gpu = Get-CimInstance Win32_VideoController # Récupération de toutes les configurations de la carte graphique
$nomCarteGraphique = $gpu.Name               # Attribuation du nom de la carte graphique sur la variable $nomCarteGraphique 

$cpu = Get-CimInstance Win32_Processor       # Récupération de toutes les configurations du processeur
$nomProcesseur = $cpu.Name                   # Attribuation du nom de la carte graphique sur la variable $nomProcesseur

$ram = Get-CimInstance Win32_ComputerSystem  # Récupération de toutes les configurations de la RAM
$GOram = $ram.TotalPhysicalMemory / 1024 / 1024 / 1024 # Attribuation du nom de la carte graphique sur la variable $GOram, ( /1024 x 3 pour les convertir en GO)

$action = "Verification du materiel PC"
$data = $env:COMPUTERNAME 

switch ($valeur)
{
    3 # Si $valeur = 3, alors
    {


     $logs = "INSERT INTO logs (action,date,data,cpu,gpu,ram) VALUES ('$action',now(),'$data','$nomProcesseur','$nomCarteGraphique', '$GOram');" # Récupère les valeurs pour les ajoutés dans la BDD
     $result = Execute-MySQLNonQuery $conn $logs # Script MySQL

    clear 
    $texte
    Write-Host "INFORMATION DU PC :"
    write-host "`n" # SAUT DE LIGNE
    Write-Host "NOM DE LA CARTE GRAPHIQUE : $nomCarteGraphique"
    Write-Host "NOM DU PROCESSEUR : $nomProcesseur"
    Write-Host "QUANTITE DE RAM : $GOram"
    write-host "`nAppuyer sur ENTRER pour continuer..."  -ForegroundColor Green
    Read-Host

    }

    }

