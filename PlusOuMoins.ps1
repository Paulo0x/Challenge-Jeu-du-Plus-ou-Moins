<#
.SYNOPSIS
    Jeu du Plus ou Moins interactif.
.DESCRIPTION
    Un jeu console ou l'utilisateur doit deviner un nombre genere par l'ordinateur
    ou un autre joueur, avec gestion des scores et niveaux de difficulte.
.PARAMETER Nom
    Nom du joueur pour l'enregistrement du score.
.NOTES
    Auteur: Ton Nom
    Date: 02/02/2026
#>

# --- Fonctions de gestion des donnees ---
# Sauvegarde les resultats dans un fichier CSV local
function Sauvegarder-Score($nom, $niveau, $tentatives) { ... }

# --- Menu Principal et Logique du Jeu ---
# Boucle principale permettant de rejouer
while ($rejouer -eq "o") { ... }



$fichierScores = "scores.csv"

# 8.1 - Fonction pour sauvegarder
function Sauvegarder-Score($nom, $niveau, $tentatives) {
    $date = Get-Date -Format "dd/MM/yyyy HH:mm"
    $ligne = "$nom,$niveau,$tentatives,$date"
    $ligne | Out-File -FilePath $fichierScores -Append -Encoding utf8
}

# 8.1 - Fonction pour afficher le tableau des scores
function Afficher-Scores {
    if (Test-Path $fichierScores) {
        Write-Host "`n--- TABLEAU DES MEILLEURS SCORES ---" -ForegroundColor Magenta
        $scores = Import-Csv -Path $fichierScores -Header "Nom","Niveau","Tentatives","Date"
        $scores | Sort-Object {[int]$_.Tentatives} | Select-Object -First 10 | Format-Table
    } else {
        Write-Host "`nPas encore de scores enregistres." -ForegroundColor Yellow
    }
    Read-Host "`nAppuyez sur Entree pour revenir au menu"
}

$rejouer = "o"
while ($rejouer -eq "o") {
    Clear-Host
    Write-Host "=== JEU DU PLUS OU MOINS v3.1 ===" -ForegroundColor Cyan
    Write-Host "1. Jouer Solo"
    Write-Host "2. Jouer Duel (2 joueurs)"
    Write-Host "3. Voir les scores"
    Write-Host "4. Quitter"
    $menu = Read-Host "Votre choix"

    if ($menu -eq "3") { Afficher-Scores; continue }
    if ($menu -eq "4") { break }

    $nomJoueur = Read-Host "Entrez votre nom"
    
    if ($menu -eq "2") {
        $nombreADevinerSaisie = Read-Host -AsSecureString "Joueur 1, entrez le nombre"
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($nombreADevinerSaisie)
        $nombreADeviner = [int][System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        $limiteMax = 100; $niveau = "Duel"; Clear-Host
    } else {
        Write-Host "1.Facile 2.Moyen 3.Difficile"
        $nv = Read-Host "Niveau"
        switch ($nv) {
            "1" { $max=50; $limiteMax=15; $niveau="Facile" }
            "3" { $max=200; $limiteMax=8; $niveau="Difficile" }
            Default { $max=100; $limiteMax=10; $niveau="Moyen" }
        }
        $nombreADeviner = Get-Random -Minimum 1 -Maximum ($max + 1)
    }

    $tentatives = 0; $trouve = $false
    while (-not $trouve -and $tentatives -lt $limiteMax) {
        $saisie = Read-Host "Proposition"
        if ($saisie -as [int] -eq $null) { continue }
        $essai = [int]$saisie
        $tentatives++

        if ($essai -eq $nombreADeviner) {
            Write-Host "Gagne en $tentatives essais !" -ForegroundColor Cyan
            Sauvegarder-Score $nomJoueur $niveau $tentatives # Sauvegarde auto
            $trouve = $true
        } elseif ($essai -lt $nombreADeviner) { Write-Host "Plus grand" -ForegroundColor Blue }
        else { Write-Host "Plus petit" -ForegroundColor Green }
    }

    $rejouer = Read-Host "Rejouer ? (o/n)"
}