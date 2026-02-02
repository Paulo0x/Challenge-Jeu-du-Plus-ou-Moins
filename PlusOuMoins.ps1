$historiqueScores = @()
$rejouer = "o"

while ($rejouer -eq "o") {
    Clear-Host
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "   JEU DU PLUS OU MOINS v2.0" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Regles : Devinez le nombre entre 1 et 100." -ForegroundColor Yellow
    Write-Host "Attention : Vous avez 10 tentatives maximum !" -ForegroundColor Red

    $nombreADeviner = Get-Random -Minimum 1 -Maximum 101
    $nombreTentatives = 0
    $limiteMax = 10
    $trouve = $false

    while (-not $trouve -and $nombreTentatives -lt $limiteMax) {
        $tentativesRestantes = $limiteMax - $nombreTentatives
        Write-Host "`nTentatives restantes : $tentativesRestantes" -ForegroundColor Yellow
        
        $saisie = Read-Host "Votre proposition"
        
        # Validation des entrees (Etape 4)
        if ($saisie -as [int] -eq $null) {
            Write-Host "Erreur : Veuillez entrer un nombre valide." -ForegroundColor Red
            continue
        }

        $essai = [int]$saisie
        if ($essai -lt 1 -or $essai -gt 100) {
            Write-Host "Erreur : Entre 1 et 100 svp." -ForegroundColor Red
            continue
        }

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
        Write-Host "`nDommage ! Vous avez depasse les 10 essais." -ForegroundColor Red
        Write-Host "Le nombre etait : $nombreADeviner" -ForegroundColor Yellow
    }

    # Affichage du meilleur score (Etape 5.1)
    if ($historiqueScores.Count -gt 0) {
        $meilleurScore = ($historiqueScores | Measure-Object -Minimum).Minimum
        Write-Host "`nVotre meilleur score actuel : $meilleurScore" -ForegroundColor Magenta
    }

    $rejouer = Read-Host "`nVoulez-vous rejouer ? (o/n)"
}

Write-Host "`nMerci d'avoir joue ! A bientot." -ForegroundColor Cyan