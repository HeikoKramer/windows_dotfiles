# Shell-Ai.ps1

# Globale Chat-Historie initialisieren (Falls noch nicht vorhanden)
if (-not $global:chatHistory) {
    $global:chatHistory = @()
}

function Invoke-ShellAi {
    param(
        [Parameter(Mandatory)]
        [string]$Prompt
    )

    # API-Key aus der Umgebungsvariable abrufen
    $apiKey = $env:openAI_APIKEY
    if (-not $apiKey) {
        Write-Error "Der API-Key wurde nicht gefunden. Bitte setze die Umgebungsvariable openAI_APIKEY."
        return
    }

    # Füge die Benutzereingabe zur globalen Chat-Historie hinzu
    $global:chatHistory += @{ role = "user"; content = $Prompt }

    # Erstelle den Anfrage-Body als Hash
    $bodyHash = @{
        model      = "gpt-3.5-turbo"
        messages   = $global:chatHistory
        max_tokens = 150
    }

    # JSON-String erzeugen (ohne -Compress), anschließend UTF-8-Bytearray
    $bodyJson = $bodyHash | ConvertTo-Json -Depth 10
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyJson)

    # Header und API-Endpunkt definieren
    $headers = @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type"  = "application/json; charset=utf-8"
    }
    $apiUrl = "https://api.openai.com/v1/chat/completions"

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $bodyBytes
        $outputContent = $response.choices[0].message.content.Trim()
        
        # Füge die Assistenz-Antwort zum Konversationsverlauf hinzu
        $global:chatHistory += @{ role = "assistant"; content = $outputContent }

        # Ausgabe: Falls verfügbar, als Markdown anzeigen; ansonsten normal ausgeben
        if (Get-Command Show-Markdown -ErrorAction SilentlyContinue) {
            $outputContent | Show-Markdown
        } else {
            Write-Host $outputContent
        }
    }
    catch {
        Write-Error "Beim Aufruf der OpenAI API ist ein Fehler aufgetreten: $_"
    }
}

function Start-ShellAi {
    Write-Host "Willkommen bei Shell-Ai! (Tippe 'exit', um zu beenden)"
    while ($true) {
        $userInput = Read-Host "Du"
        if ($userInput -eq "exit") { break }
        Invoke-ShellAi -Prompt $userInput
    }
}

# Alias 'shai' für die interaktive Nutzung erstellen
Set-Alias -Name shai -Value Start-ShellAi

function Test-OpenAIKey {
    # API-Key aus der Umgebungsvariable abrufen
    $apiKey = $env:openAI_APIKEY
    if (-not $apiKey) {
        Write-Error "API-Key wurde nicht gefunden. Bitte setze die Umgebungsvariable openAI_APIKEY."
        return
    }

    # Test-Endpoint für minimalen Request
    $apiUrl = "https://api.openai.com/v1/embeddings"
    $headers = @{
        "Authorization" = "Bearer $apiKey"
        "Content-Type"  = "application/json"
    }

    # Anfrage-Body mit minimalem Input
    $body = @{
        input = "Hello world"
        model = "text-embedding-ada-002"
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body $body
        Write-Host "API-Key ist gültig! Erhaltener Response:"
        Write-Output $response
    }
    catch {
        Write-Error "Fehler bei der Verbindung mit der OpenAI API: $_"
    }
}

# Alias 'tai' für den Test des API-Keys
Set-Alias -Name tai -Value Test-OpenAIKey