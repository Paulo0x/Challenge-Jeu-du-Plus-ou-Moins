$historiqueScores = @()
$rejouer = "o"

while ($rejouer -eq "o") {
    Clear-Host
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "   JEU DU PLUS OU MOINS v3.0" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan

    # 7.1 - Choix du mode
    Write-Host "Choisissez le mode de jeu :" -ForegroundColor Yellow
    Write-Host "1. Un joueur contre l'ordinateur"
    Write-Host "2. Deux joueurs"
    $mode = Read-Host "Votre choix (1 ou 2)"

    if ($mode -eq "2") {
        # 7.2 - Mode deux joueurs
        Write-Host "`nJoueur 1 : Choisissez un nombre a faire deviner." -ForegroundColor Magenta
        $nombreADevinerSaisie = Read-Host -AsSecureString "Entrez le nombre (masque)"
        # Convertir la saisie masquee en nombre utilisable
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($nombreADevinerSaisie)
        $nombreADeviner = [int][System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        $limiteMax = 100 # Pas de limite stricte en duel, ou tu peux en fixer une
        $maxNombre = "Inconnu"
        $niveau = "Duel"
        Clear-Host
        Write-Host "C'est au Joueur 2 de deviner !" -ForegroundColor Cyan
    }
    else {
        # Mode Solo (Etape 6)
        Write-Host "`nNiveaux de difficulte :" -ForegroundColor Yellow
        Write-Host "1. Facile (1-50, 15 tentatives)"
        Write-Host "2. Moyen (1-100, 10 tentatives)"
        Write-Host "3. Difficile (1-200, 8 tentatives)"
        $choixNiveau = Read-Host "Votre choix (1, 2 ou 3)"
        
        switch ($choixNiveau) {
            "1" { $maxNombre = 50; $limiteMax = 15; $niveau = "Facile" }
            "3" { $maxNombre = 200; $limiteMax = 8; $niveau = "Difficile" }
            Default { $maxNombre = 100; $limiteMax = 10; $niveau = "Moyen" }
        }
        $nombreADeviner = Get-Random -Minimum 1 -Maximum ($maxNombre + 1)
        $niveauNom = $niveau
    }

    $nombreTentatives = 0
    $trouve = $false

    while (-not $trouve -and $nombreTentatives -lt $limiteMax) {
        $tentativesRestantes = $limiteMax - $nombreTentatives
        Write-Host "`n[$niveau] Tentatives : $nombreTentatives | Max : $limiteMax" -ForegroundColor Yellow
        
        $saisie = Read-Host "Votre proposition"
        
        if ($saisie -as [int] -eq $null) {
            Write-Host "Erreur : Nombre invalide." -ForegroundColor Red
            continue
        }

        $essai = [int]$saisie
        $nombreTentatives++

        if ($essai -eq $nombreADeviner) {
            Write-Host "Bravo ! Le nombre a ete trouve en $nombreTentatives essais !" -ForegroundColor Cyan
            if ($mode -ne "2") { $historiqueScores += $nombreTentatives }
            $trouve = $true
        }
        elseif ($essai -lt $nombreADeviner) {
            Write-Host "C'est Plus grand !" -ForegroundColor Blue
        }
        else {
            Write-Host "C'est Plus petit !" -ForegroundColor Green
        }
    }

    if (-not $trouve) {
        Write-Host "`nPerdu ! Le nombre etait : $nombreADeviner" -ForegroundColor Red
    }

    $rejouer = Read-Host "`nVoulez-vous rejouer ? (o/n)"
}

Write-Host "`nMerci d'avoir joue ! Fin du challenge." -ForegroundColor Cyan