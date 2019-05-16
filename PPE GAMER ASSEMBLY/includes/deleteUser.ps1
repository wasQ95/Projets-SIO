#    ____    _____   _       _____   _____   _____     _   _   ____    _____   ____    ____  
#   |  _ \  | ____| | |     | ____| |_   _| | ____|   | | | | / ___|  | ____| |  _ \  / ___| 
#   | | | | |  _|   | |     |  _|     | |   |  _|     | | | | \___ \  |  _|   | |_) | \___ \ 
#   | |_| | | |___  | |___  | |___    | |   | |___    | |_| |  ___) | | |___  |  _ <   ___) |
#   |____/  |_____| |_____| |_____|   |_|   |_____|    \___/  |____/  |_____| |_| \_\ |____/ 
#                                                                                            


$verif ++ # Verification du script
   switch ($valeur) 
{ # DEBUT DU SCRIPT SWITCH
 
   2  # Si $valeur = 2 , alors ...
    {

    clear
    $texte
    
        DO {

    Write-Host "VOUS AVEZ CHOISI LA SUPPRESSION DES UTILISATEURS"
    $query = "SELECT * FROM jeux;"            # Selection de tout les jeux de la BDD
    $result = Execute-MySQLQuery $conn $query # Execute le script MySQL dans la BDD
    $result | Format-Table                    # Affichage en format de tableau la liste des jeux

#        id nom
#        -- ---
#        1 FIFA19
#        2 FORTNITE
#        3 LEAGUE OF LEGENDS
#        4 COUNTER STRIKE GLOBAL OFFENSIVE
#        5 STARCRAFT II


       $idJeu = read-host "Veuillez choisir l'ID du jeu " 
        $query = "SELECT nom FROM jeux WHERE id  = $idJeu"  # Récupère le jeu choisi avec $idJeu
    $result = Execute-MySQLQuery $conn $query               # Execute le script MySQL dans la BDD
   $nomdujeu = $result[1].nom                               # Récupère le nom du jeu ".nom " , grace au tableau " [] "


   clear  # Efface tout afin que ce soit plus lisible
   $texte # Garde le "symbole" de la LAN



       $pseudo = "SELECT pseudo FROM joueurs WHERE idJeu = $idJeu" # Récupère les pseudos relié à la clé étrangère "$idJeu"

            } WHILE($idJeu -GT 5 -OR $idJeu -EQ 0 -OR !$idJeu)      # On reboucle si la valeur $idJeu est plus grande que 5; égal à 0;aucune valeur saisie

    $result = Execute-MySQLQuery $conn $pseudo
    $joueurSelonJeu = $result                                      # Attribue les résultats à la variable "$joueurSelonJeu"
    write-host "SUPPRESSION DES COMPTES UTILISATEURS..."


  
     $ind = 0 # Initialisation pour compter les utilisateurs supprimé
      foreach ($joueur in $joueurSelonJeu)    # Pour chaque joueur avec $idJeu alors ...
  {  # DEBUT DE BOUCLE
      $compte = $joueur.pseudo                # On prend leurs pseudo et on les stocks dans $compte
      $action = "Suppression compte $compte"  # Variable utilisé pour les LOGS, il récupère le nom de compte supprimé
      $data = $env:COMPUTERNAME               # Variable utilisé pour les LOGS, il récupère le nom du PC



      if ($compte -notlike "")                # Si le compte à + d'un caractère alors... ( Utilisé pour évité les erreurs MySQL qui ajoute ou supprime un utilisateur sans nom)
       { # DEBUT DU IF
      Remove-LocalUser -Name "$compte" -Verbose   # On supprime les pseudo stocké dans $compte, avec -Verbose pour un descriptif de ce qu'il se passe
      $ind ++                                     # ind qui s'incrémente à chaque passage de boucle pour compter le nombre d'utilisateurs supprimé
      $logs = "INSERT INTO logs (action,date,data,cpu,gpu,ram) VALUES ('$action',now(),'$data','$nomProcesseur','$nomCarteGraphique', '$GOram');" # On insert dans la table logs "action,date,data,cpu,gpu,ram" , les valeurs attribué
      $result = Execute-MySQLNonQuery $conn $logs # Pour l'execution MySQL
       } #FIN DU IF
   }  # FIN DE BOUCLE




      write-host "-------------------------------------------" 
      write-host "SUPPRESSION DU GROUPE LOCAL '$nomdujeu'" # Nous informe la suppression du groupe local
      Remove-LocalGroup -Name "$nomdujeu" -Verbose         # Suppression du groupe local
     


     write-host "`n $ind comptes on été supprimé avec succès" -ForegroundColor Green # `n pour le saut de ligne ; Nous informe le nombres de comptes supprimé ; -ForegroundColor Green pour la couleur de texte
      write-host "`nAppuyer sur ENTRER pour continuer..." -ForegroundColor Green
      Read-Host
    }
} # FIN DU SCRIPT SWITCH