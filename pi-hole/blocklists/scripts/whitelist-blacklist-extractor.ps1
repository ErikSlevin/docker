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
    tar -xzf $downloadedFile.FullName -C $extractedPath whitelist.exact.json adlist.json

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
    
    # Pfad zur Ausgabedatei für Whitelists
    $whitelistOutputFilePath = "$env:USERPROFILE\Documents\GitHub\docker\pi-hole\blocklists\whitelists"
    
    # Inhalt des Whitelist-Headers
    $whitelistHeader = @"
####################################################################################################
#### WHITELISTS ####################################################################################
#### Released: $(Get-Date -Format "dd.MM.yyyy 'at' HH:mm")
####
#### Count: $($domains.Count) Domains von $($sortedStammdomains.Count) Anbietern.
####
#### GitHub: https://github.com/ErikSlevin
#### Repository: https://github.com/ErikSlevin/docker/tree/main/pi-hole/
####
#### Copyright Erik Slevin #########################################################################
####################################################################################################

"@

    # Entferne die Einrückung am Anfang jeder Zeile
    $whitelistHeader = $whitelistHeader -replace "(?m)^\s+", ""
    
    # Schreibe den Whitelist-Header in die Ausgabedatei (überschreibe vorhandene Datei)
    $whitelistHeader | Set-Content -Path $whitelistOutputFilePath
    
    # Schreibe die gruppierten Domains in die Ausgabedatei (anfügen)
    foreach ($stammdomain in $sortedStammdomains) {
        # Schreibe die Stammdomain in Großbuchstaben
        "#### $($stammdomain.ToUpper())" | Add-Content -Path $whitelistOutputFilePath
        
        $subdomains = $stammdomains[$stammdomain] | Sort-Object
        
        # Schreibe die Unterdomänen
        foreach ($subdomain in $subdomains) {
            $subdomain | Add-Content -Path $whitelistOutputFilePath
        }
        
        # Füge eine leere Zeile hinzu
        Add-Content -Path $whitelistOutputFilePath ""
    }

    # SSH-Verbindung zum Pi-hole-Server herstellen
    Write-Host "Verbindung zum Pi-hole-Server herstellen..."
    ssh $serverName -t "docker exec -it pihole /bin/bash -c 'pihole -c -j'" | Out-File -FilePath "$localPath\pihole_stats.json"

    # Lade den Inhalt der Pi-hole-Statistik-JSON
    $piholeStats = Get-Content -Path "$localPath\pihole_stats.json" | ConvertFrom-Json

    # Extrahiere die Anzahl der blockierten Domains
    $totalBlockedDomains = $piholeStats.domains_being_blocked

    $jsonData = Get-Content -Raw -Path "$env:USERPROFILE\Downloads\extracted\adlist.json" | ConvertFrom-Json

    $extractedData = @()
    $totalNumber = 0
    $totalInvalidDomains = 0

    foreach ($item in $jsonData) {
        $address = $item.address -replace '\\', ''
        $comment = $item.comment
        $number = $item.number
        $invalidDomains = $item.invalid_domains

        $extractedData += [PSCustomObject]@{
            Address = $address
            Comment = $comment
            Number = $number
            InvalidDomains = $invalidDomains
        }

        $totalNumber += $number
        $totalInvalidDomains += $invalidDomains
    }

    $outputPath = Join-Path "$env:USERPROFILE\Documents\GitHub\docker\pi-hole\blocklists\" "blocklists"

    $groupedData = $extractedData | Group-Object -Property Comment

    #$separator = "#" * 100
    $lineBreaks = "`n"

    $blocklistHeader = @"
####################################################################################################
#### BLOCKLISTS ####################################################################################
#### Released: $(Get-Date -Format "dd.MM.yyyy 'at' HH:mm")
####
#### Count: $($totalNumber.ToString("#,###")) Domains ($($totalBlockedDomains.ToString("#,###")) unique) in $($jsonData.Count) Adlists in $($groupedData.Count) Categories.
####
#### GitHub: https://github.com/ErikSlevin
#### Repository: https://github.com/ErikSlevin/docker/tree/main/pi-hole/
####
#### Copyright Erik Slevin #########################################################################
####################################################################################################
"@

    # Lösche die Ausgabedatei, wenn sie bereits vorhanden ist
    if (Test-Path $outputPath) {
        Remove-Item $outputPath -Force
    }

    $blocklistHeader | Out-File -FilePath $outputPath -Encoding UTF8 -Append

    foreach ($group in $groupedData) {
        $comment = $group.Name.Replace("&amp; ", "& ")
        $commentLength = $comment.Length
        $paddingLength = 100 - $commentLength - 6
        $padding = "#" * $paddingLength

        $output = "$lineBreaks`n#### $comment $padding `n$lineBreaks"

        foreach ($address in $group.Group) {
            $output += "$($address.Address)`n"
        }

        $output | Out-File -FilePath $outputPath -Encoding UTF8 -Append
    }
} else {
    Write-Host "Keine Datei mit dem Muster '*pihole-backup.tar.gz' gefunden."
}
