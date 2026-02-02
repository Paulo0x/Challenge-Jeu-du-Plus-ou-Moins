<#
.SYNOPSIS
    Version Ultime du Jeu Plus ou Moins - TechSecure Edition.
.DESCRIPTION
    Inclut : Mode Solo/Duel, Niveaux, Sauvegarde CSV, Indices, Sons et Stats.
#>

$fichierScores = "scores.csv"

# --- SYSTEME SONORE & VISUEL ---
function Jouer-Son($type) {
    if ($type -eq "plus") { [console]::Beep(440, 200) }
    elseif ($type -eq "moins") { [console]::Beep(330, 200) }
    elseif ($type -eq "victoire") { 
        foreach($f in @(523, 659, 783, 1046)) { [console]::Beep($f, 150) }
    }
}

function Afficher-Trophy {
    Write-Host @"
      ___________
     '._==_==_=_.'
     .-\:      /-.
    | (|:.     |) |
     '-|:.     |-'
       \::.    /
        '::. .'
          ) (
        _.' '._
       `-------`
"@ -ForegroundColor Yellow
}

# --- GESTION DES SCORES ---
function Sauvegarder-Score($nom, $niveau, $tentatives, $succes) {
    $date = Get-Date -Format "dd/MM/yyyy HH:mm"
    $statut = if ($succes) { "Victoire" } else { "Defaite" }
    "$nom,$niveau,$tentatives,$statut,$date" | Out-File $fichierScores -Append -Encoding utf8
}

function Afficher-Stats {
    if (Test-Path $fichierScores) {
        $data = Import-Csv $fichierScores -Header "Nom","Niveau","Tentatives","Resultat","Date"
        $total = $data.Count
        $victoires = ($data | Where-Object { $_.Resultat -eq "Victoire" }).Count
        $taux = [Math]::Round(($victoires / $total) * 100, 1)
        
        Write-Host "`n=== STATISTIQUES GLOBALES ===" -ForegroundColor Magenta
        Write-Host "Parties jouees : $total"
        Write-Host "Taux de victoire : $taux %" -ForegroundColor Cyan
        $data | Sort-Object {[int]$_.Tentatives} | Select-Object -First 5 | Format-Table
    }
    Read-Host "`nAppuyez sur Entree..."
}

# --- BOUCLE PRINCIPALE ---
$rejouer = "o"
while ($rejouer -eq "o") {
    Clear-Host
    Write-Host "   TECHSECURE - PLUS OU MOINS PRO v4.0" -ForegroundColor Cyan -BackgroundColor DarkBlue
    Write-Host "1. Solo | 2. Duel | 3. Stats | 4. Quitter" -ForegroundColor Yellow
    $choix = Read-Host "Action"

    if ($choix -eq "3") { Afficher-Stats; continue }
    if ($choix -eq "4") { break }

    $nom = Read-Host "Nom du joueur"
    
    # Configuration Niveau (Etape 6)
    if ($choix -eq "1") {
        Write-Host "1.Facile(50) 2.Moyen(100) 3.Difficile(200)"
        $nv = Read-Host "Niveau"
        switch($nv) {
            "1" { $max=50; $limMax=15; $niv="Facile" }
            "3" { $max=200; $limMax=8; $niv="Difficile" }
            Default { $max=100; $limMax=10; $niv="Moyen" }
        }
        $target = Get-Random -Minimum 1 -Maximum ($max+1)
    } else {
        $target = [int](Read-Host -AsSecureString "Nombre a deviner (masque)")
        $max=100; $limMax=10; $niv="Duel"
    }

    $tentatives = 0; $trouve = $false
    while (-not $trouve -and $tentatives -lt $limMax) {
        Write-Host "`nEssai $($tentatives+1)/$limMax" -ForegroundColor Gray
        
        # Indice Intelligent (Etape 10.1)
        if ($tentatives -eq 5) {
            $parite = if ($target % 2 -eq 0) { "Pair" } else { "Impair" }
            Write-Host "[INDICE] Le nombre est $parite !" -ForegroundColor Cyan
        }

        $saisie = Read-Host "Votre choix"
        if ($saisie -as [int] -eq $null) { Write-Host "Nombre valide svp" -ForegroundColor Red; continue }
        $essai = [int]$saisie
        $tentatives++

        if ($essai -eq $target) {
            Afficher-Trophy
            Write-Host "INCROYABLE ! Trouve en $tentatives essais." -ForegroundColor Cyan
            Jouer-Son "victoire"
            Sauvegarder-Score $nom $niv $tentatives $true
            $trouve = $true
        } elseif ($essai -lt $target) {
            Write-Host "C'est PLUS !" -ForegroundColor Blue
            Jouer-Son "plus"
        } else {
            Write-Host "C'est MOINS !" -ForegroundColor Green
            Jouer-Son "moins"
        }
    }

    if (-not $trouve) {
        Write-Host "GAME OVER. Le nombre etait $target." -ForegroundColor Red
        Sauvegarder-Score $nom $niv $tentatives $false
    }

    $rejouer = Read-Host "Rejouer ? (o/n)"
}