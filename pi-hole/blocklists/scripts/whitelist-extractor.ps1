$serverName = "Docker-Pi-1"
$remotePath = "/home/erik/backup/"
$localPath = "$env:USERPROFILE\Downloads\"
$extractedPath = "$localPath\extracted\"

$sourcePath = "$serverName`:$remotePath*pihole-backup.tar.gz"
$directoryPath = "$localPath"

# Herunterladen der Datei mit SCP
scp $sourcePath $directoryPath

# Suchen der heruntergeladenen Datei mit Wildcard
$downloadedFile = Get-ChildItem -Path $directoryPath -Filter "*pihole-backup.tar.gz" | Select-Object -First 1

if ($downloadedFile) {
    # Erstellen des Extraktionsverzeichnisses, falls es nicht existiert
    if (-not (Test-Path -Path $extractedPath)) {
        New-Item -ItemType Directory -Path $extractedPath | Out-Null
    }

    # Extrahieren der heruntergeladenen Datei
    Write-Host "Entpacken der heruntergeladenen Datei..."
    tar -xzf $downloadedFile.FullName -C $extractedPath whitelist.exact.json

    # Löschen der ursprünglichen Datei
    Write-Host "Löschen der ursprünglichen Datei..."
    Remove-Item -Path $downloadedFile.FullName -Force

    # Pfad zur extrahierten whitelist.exact.json
    $extractedFilePath = Join-Path -Path $extractedPath -ChildPath "whitelist.exact.json"

    # Lade den Inhalt der JSON-Datei
    $jsonContent = Get-Content -Path $extractedFilePath -Raw | ConvertFrom-Json

    # Extrahiere die Domains aus der JSON
    $domains = $jsonContent | Select-Object -ExpandProperty domain
    $domains = $domains -replace "^www\."

    $stammdomains = @{}

    foreach ($domain in $domains | Select-Object -Unique) {
        $parts = $domain -split "\."
        
        if ($parts.Count -ge 2) {
            $stammdomain = $parts[-2]
            
            if ($stammdomains.ContainsKey($stammdomain)) {
                $stammdomains[$stammdomain] += @($domain)
            }
            else {
                $stammdomains[$stammdomain] = @($domain)
            }
        }
    }
    
    $sortedStammdomains = $stammdomains.Keys | Sort-Object
    
    # Pfad zur Ausgabedatei
    $outputFilePath = "$env:USERPROFILE\Documents\GitHub\docker\pi-hole\blocklists\whitelists"
    
    # Inhalt des Headers
    $header = @"
####################################################################################################
#### WHITELISTS ####################################################################################
#### Released: $(Get-Date -Format "dd.MM.yyyy 'at' HH:mm")
####
#### Count: $($sortedDomains.Count) Domains von $($sortedStammdomains.Count) Anbietern.
####
#### GitHub: https://github.com/ErikSlevin
#### Repository: https://github.com/ErikSlevin/docker/tree/main/pi-hole/
####
#### Copyright Erik Slevin #########################################################################
####################################################################################################
"@

    # Entferne die Einrückung am Anfang jeder Zeile
    $header = $header -replace "(?m)^\s+", ""
    
    # Schreibe den Header in die Ausgabedatei (überschreibe vorhandene Datei)
    $header | Set-Content -Path $outputFilePath
    
    # Schreibe die gruppierten Domains in die Ausgabedatei (anfügen)
    foreach ($stammdomain in $sortedStammdomains) {
        # Schreibe die Stammdomain in Großbuchstaben
        "#### $($stammdomain.ToUpper())" | Add-Content -Path $outputFilePath
        
        $subdomains = $stammdomains[$stammdomain] | Sort-Object
        
        # Schreibe die Unterdomänen
        foreach ($subdomain in $subdomains) {
            $subdomain | Add-Content -Path $outputFilePath
        }
        
        # Füge eine leere Zeile hinzu
        Add-Content -Path $outputFilePath ""
    }

} else {
    Write-Host "Keine Datei mit dem Muster '*pihole-backup.tar.gz' gefunden."
}
