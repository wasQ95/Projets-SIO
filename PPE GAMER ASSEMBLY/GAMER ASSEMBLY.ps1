$texte = "
-------------------------------------------------------------------------------------------------------------------
                                                                                                                  |
 ██████╗  █████╗ ███╗   ███╗███████╗██████╗      █████╗ ███████╗███████╗███████╗███╗   ███╗██████╗ ██╗  ██╗   ██╗ |
██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗    ██╔══██╗██╔════╝██╔════╝██╔════╝████╗ ████║██╔══██╗██║  ╚██╗ ██╔╝ |
██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝    ███████║███████╗███████╗█████╗  ██╔████╔██║██████╔╝██║   ╚████╔╝  |
██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗    ██╔══██║╚════██║╚════██║██╔══╝  ██║╚██╔╝██║██╔══██╗██║    ╚██╔╝   |
╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║    ██║  ██║███████║███████║███████╗██║ ╚═╝ ██║██████╔╝███████╗██║    |
 ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝╚═════╝ ╚══════╝╚═╝    |
                                                                                                                  |
-------------------------------------------------------------------------------------------------------------------                                                 
"



$texte
write-host "VERIFICATION DES SCRIPTS..." -ForegroundColor Green
write-host "SI IL Y A UNE ATTENTE DE + DE 5 SECONDES, MERCI DE FAIRE ENTRÉE." -ForegroundColor Green
Write-Host "`n"

$verif = -2
$chemin = "C:\Users\Administrateur\Desktop\GAMERASSEMBLY\includes" # CHEMIN POUR APPELER LES PROCHAINS SCRIPTS
. "$chemin\mysql.ps1"               # VERIF DU SCRIPT MYSQL
. "$chemin\CreateUserEtLocalGp.ps1" # VERIF POUR LE COMPTEUR DE SCRIPT
. "$chemin\deleteUser.ps1"          # VERIF POUR LE COMPTEUR DE SCRIPT
. "$chemin\materiel.ps1"            # VERIF POUR LE COMPTEUR DE SCRIPT 



do {
if ($verif -eq 4)                   # Si script = 4/4, Alors on informe que SCRIPT OK...
{
write-host "SCRIPT OK... $verif / 4" -ForegroundColor Green
Write-Host "`n"
}
else { 

write-host "IL MANQUE UN SCRIPT... $verif / 4" -ForegroundColor RED
Write-Host "L'APPLICATION RISQUE DE PAS BIEN FONCTIONNER..." -ForegroundColor RED
Write-Host "`n"



}                     # Boucle pour eviter l'erreur, relié au while




clear
$texte
                        #CHOIX
Write-Host "Bonjour !, voulez-vous la création, ou la suppression d'utilisateur ?"
write-host "[1] Création des utilisateurs"
write-host "[2] Suppression des utilisateurs"
write-host "[3] Voir les informations du PC"
$valeur = 0
$valeur = Read-Host
}
while ($valeur -GT 3 -OR $valeur -EQ 0 -OR !$valeur)    # Tant que la valeur est plus grande que 4 , rejoue le DO



$conn = Connect-MySQL  # CONNEXION A LA BASE DE DONNEES

. "$chemin\CreateUserEtLocalGp.ps1" # APPEL DU SCRIPT DE CREATION SI VALEUR = 1
. "$chemin\deleteUser.ps1"          # APPEL DU SCRIPT DE SUPPRESSION SI VALEUR = 2
. "$chemin\materiel.ps1"            # APPEL DU SCRIPT DE D'INFORMATIONS SI VALEUR  = 3
