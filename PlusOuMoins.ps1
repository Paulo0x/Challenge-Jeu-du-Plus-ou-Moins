$historiqueScores = @()
$rejouer = "o"

while ($rejouer -eq "o") {
    Clear-Host
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "   JEU DU PLUS OU MOINS v2.1" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan

    # 6.1 - Choix du niveau de difficulte
    Write-Host "Choisissez votre niveau :" -ForegroundColor Yellow
    Write-Host "1. Facile (1-50, 15 tentatives)"
    Write-Host "2. Moyen (1-100, 10 tentatives)"
    Write-Host "3. Difficile (1-200, 8 tentatives)"
    
    $choix = Read-Host "Votre choix (1, 2 ou 3)"
    
    switch ($choix) {
        "1" { $maxNombre = 50; $limiteMax = 15; $niveau = "Facile" }
        "3" { $maxNombre = 200; $limiteMax = 8; $niveau = "Difficile" }
        Default { $maxNombre = 100; $limiteMax = 10; $niveau = "Moyen" }
    }

    $nombreADeviner = Get-Random -Minimum 1 -Maximum ($maxNombre + 1)
    $nombreTentatives = 0
    $trouve = $false

    Write-Host "`nNiveau choisi : $niveau" -ForegroundColor Magenta

    while (-not $trouve -and $nombreTentatives -lt $limiteMax) {
        $tentativesRestantes = $limiteMax - $nombreTentatives
        Write-Host "`n[$niveau] Tentatives restantes : $tentativesRestantes" -ForegroundColor Yellow
        
        $saisie = Read-Host "Votre proposition (1-$maxNombre)"
        
        if ($saisie -as [int] -eq $null) {
            Write-Host "Erreur : Veuillez entrer un nombre valide." -ForegroundColor Red
            continue
        }

        $essai = [int]$saisie
        $nombreTentatives++

        if ($essai -eq $nombreADeviner) {
            Write-Host "Bravo ! Vous avez trouve en $nombreTentatives essais !" -ForegroundColor Cyan
            $historiqueScores += $nombreTentatives
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
        Write-Host "`nDommage ! Le nombre etait : $nombreADeviner" -ForegroundColor Red
    }

    if ($historiqueScores.Count -gt 0) {
        $meilleurScore = ($historiqueScores | Measure-Object -Minimum).Minimum
        Write-Host "`nMeilleur score de la session : $meilleurScore" -ForegroundColor Magenta
    }

    $rejouer = Read-Host "`nVoulez-vous rejouer ? (o/n)"
}

Write-Host "`nMerci d'avoir joue ! A bientot." -ForegroundColor Cyan