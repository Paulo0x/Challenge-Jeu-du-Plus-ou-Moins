# Titre coloré et message d'accueil (sans accents)
Write-Host "================================" -ForegroundColor Cyan
Write-Host "   JEU DU PLUS OU MOINS" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Regles : Devinez le nombre entre 1 et 100 choisi par l'ordinateur." -ForegroundColor Yellow

# Initialisation
$nombreADeviner = Get-Random -Minimum 1 -Maximum 101
$nombreTentatives = 0
$trouve = $false

while (-not $trouve) {
    # 4.1 - Demander une saisie
    $saisie = Read-Host "Votre proposition"
    
    # 4.1 - Verifier que l'utilisateur entre bien un nombre (pas de lettres ou vide)
    if ($saisie -as [int] -eq $null) {
        Write-Host "Erreur : Veuillez entrer un nombre valide." -ForegroundColor Red
        continue # Reprend la boucle sans compter la tentative
    }

    $essai = [int]$saisie

    # 4.1 - Verifier que le nombre est entre 1 et 100
    if ($essai -lt 1 -or $essai -gt 100) {
        Write-Host "Erreur : Le nombre doit etre compris entre 1 et 100." -ForegroundColor Red
        continue # Reprend la boucle sans compter la tentative
    }

    # Si on arrive ici, la saisie est valide
    $nombreTentatives++
    Write-Host "Tentative $nombreTentatives" -ForegroundColor Yellow

    # Comparaisons avec couleurs specifiques
    if ($essai -eq $nombreADeviner) {
        Write-Host "Felicitations ! Vous avez trouve le nombre $nombreADeviner !" -ForegroundColor Cyan
        Write-Host "Nombre total de tentatives : $nombreTentatives" -ForegroundColor Cyan
        $trouve = $true
    }
    elseif ($essai -lt $nombreADeviner) {
        Write-Host "C'est Plus grand !" -ForegroundColor Blue # Bleu pour Plus Grand
    }
    else {
        Write-Host "C'est Plus petit !" -ForegroundColor Green # Vert pour Plus Petit
    }
}