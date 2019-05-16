#       _      ____    ____      _   _   ____    _____   ____    ____  
#      / \    |  _ \  |  _ \    | | | | / ___|  | ____| |  _ \  / ___| 
#     / _ \   | | | | | | | |   | | | | \___ \  |  _|   | |_) | \___ \ 
#    / ___ \  | |_| | | |_| |   | |_| |  ___) | | |___  |  _ <   ___) |
#   /_/   \_\ |____/  |____/     \___/  |____/  |_____| |_| \_\ |____/ 
#                                                                      


$chemin = "C:\Users\Administrateur\Desktop\POWERSHELL BETA\includes" # CHEMIN POUR APPELER LES PROCHAINS SCRIPTS
. "$chemin\mysql.ps1" # Appel du script MySQL
. "$chemin\materiel.ps1" # Appel du script materiel

$verif ++ #Pour la vérification des scripts


switch ($valeur)
{ # Début du script SWITCH
    1 # Si $valeur = 1, alors 
    {
        DO {  # Boucle relié au WHILE afin d'éviter l'erreur
    
    clear
    $texte
    Write-Host "Vous avez choisis la création de compte utilisateur"
    Write-Host "Sur quel jeu souhaité-vous crée les utilisateurs ? "
   
    $query = "SELECT * FROM jeux;"             # Selection de tout les jeux de la BDD
    $result = Execute-MySQLQuery $conn $query  # Execute le script MySQL dans la BDD
    $result | Format-Table                     # Affichage en format de tableau la liste des jeux


#        id nom
#        -- ---
#        1 FIFA19
#        2 FORTNITE
#        3 LEAGUE OF LEGENDS
#        4 COUNTER STRIKE GLOBAL OFFENSIVE
#        5 STARCRAFT II



       $idJeu = read-host "Veuillez choisir l'ID du jeu " 
        $query = "SELECT nom FROM jeux WHERE id  = $idJeu" # Récupère le jeu choisi avec $idJeu

    } WHILE($idJeu -GT 5 -OR $idJeu -EQ 0 -OR !$idJeu)     # On reboucle si la valeur $idJeu est plus grande que 5; égal à 0;aucune valeur saisie

    $result = Execute-MySQLQuery $conn $query              # Execute le script MySQL dans la BDD
   $nomdujeu = $result[1].nom                              # Récupère le nom du jeu ".nom " , grace au tableau " [] "
  


   clear   #Efface tout afin que ce soit plus lisible
   $texte  # Garde le "symbole" de la LAN


                    # CREATION LOCALGROUP
    Write-Host "CREATION DU GROUPE LOCAL '$nomdujeu'..." # Récupère le nom du jeu pour en faire un groupe LOCAL
     New-LocalGroup -name "$nomdujeu"  -Verbose          # Crée le groupe local ; -verbose pour l'annoncer a l'utilisateur
       write-host "-------------------------------------------" 
       Write-Host ("CREATION DES COMPTES UTILISATEURS...") 


                    # CREATION UTILISATEURS
       $pseudo = "SELECT pseudo,mdp FROM joueurs WHERE idJeu = $idJeu"  # Selectionne les pseudos & MDP de la BDD
    $result = Execute-MySQLQuery $conn $pseudo                          # Execute le script MySQL dans la BDD
    $joueurSelonJeu = $result                                           # On met le résultat dans la variable $joueurSelonJeu
    $ind = 0                                                            # Initialisation de l'incrémentation pour compter le nombre compte ajoutés

  
      foreach ($joueur in $joueurSelonJeu)  # Pour chaque joueur dans la variable $joueurSelonJeu, alors ...
    {
      $compte = $joueur.pseudo              # On garde le pseudo dans la variable $compte
      $password = $joueur.mdp               # On garde le mot de passe dans la variable $password

      $action = "Creation compte $compte"   # Variable utilisé pour les LOGS, il récupère le nom de compte crée
      $data = $env:COMPUTERNAME             # Variable utilisé pour les LOGS, il récupère le nom du PC

      if ($compte -AND $password -notlike "")  # Si le compte à + d'un caractère alors... ( Utilisé pour évité les erreurs MySQL qui ajoute ou supprime un utilisateur sans nom)
         {

      New-LocalUser -name "$compte" -password (ConvertTo-SecureString "$password" -AsPlainText -Force) -Verbose # On crée un compte avec les pseudo stocké dans $compte, avec leurs mdp stocké dans $password, avec -Verbose pour un descriptif de ce qu'il se passe
      $ind ++ # ind qui s'incrémente à chaque passage de boucle pour compter le nombre d'utilisateurs supprimé
      Add-LocalGroupMember -group "$nomdujeu" -Member "$compte" # Création du groupe local avec le nom du jeu, ajoutant les membre $compte

      $logs = "INSERT INTO logs (action,date,data,cpu,gpu,ram) VALUES ('$action',now(),'$data','$nomProcesseur','$nomCarteGraphique', '$GOram');" # Récupère les valeurs pour les ajoutés dans la BDD
      $result = Execute-MySQLNonQuery $conn $logs # Script MySQL



        }
     }

       Write-Host "`n$ind comptes ont été crée avec succès ! " -ForegroundColor Green
      write-host "Appuyer sur ENTRER pour continuer..."  -ForegroundColor Green
      Read-Host
     }
}

