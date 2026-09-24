# =====================================================================
#   InsideEARTH - Earth 2160 Levels Downloader v1.1
# =====================================================================

# ---------------------------------------------------------------------
#  ** UNVERIFIED PLACEHOLDER DATA **
#  This game's GitHub repo, VPN/community server address, subnet and
#  level-repository were GUESSED from the Earth 2150 naming pattern -
#  they do not point at anything real yet. Confirm/replace before use:
#    GitHub repo : InsideEarth2160/Files
#    VPN server  : vpnnetserver2160.insideearth.info
#    Subnet      : 10.21.60.0/24
#    Levels repo : InsideEarth2160/Levels
# ---------------------------------------------------------------------

# Requires -Version 5.1

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Self-elevation check
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
}

clear

$host.ui.RawUI.WindowTitle = "InsideEARTH - Earth 2160 Levels Downloader"

$ErrorActionPreference = 'Stop'

# The PS 5.1 progress bar is the main cause of slow Invoke-WebRequest / Expand-Archive.
$ProgressPreference = 'SilentlyContinue'

$downloadUrl = "https://github.com/InsideEarth2160/Levels/archive/refs/heads/main.zip"
$galleryUrl  = 'https://insideearth2160.github.io/Levels-Gallery/'

# Files to remove from the Levels directory after extraction
$filesToClean = @('.gitignore', 'index.html', 'README.MD', 'style.css')

# Main loop to return to menu after any selection except Exit
while ($true) {
    Clear-Host

    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  InsideEARTH - Earth 2160 Levels Downloader v1.1" -ForegroundColor Green
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host

    $tempZipPath = Join-Path $env:TEMP "IE2160_Levels_$(Get-Random).zip"
    $tempExtractPath = Join-Path $env:TEMP "IE2160_Levels_Extract_$(Get-Random)"

    try {
        # Levels always go to Documents\Earth 2160\Levels (follows OneDrive-redirected Documents)
        $docsRoot  = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Earth 2160'
        $levelsDir = Join-Path $docsRoot 'Levels'

        Write-Host "Levels will be installed to:" -ForegroundColor Cyan
        Write-Host "  $levelsDir" -ForegroundColor White
        Write-Host ""
        Write-Host " [1] Download and install levels"
        Write-Host " [2] Exit" -ForegroundColor Red

        $selection = 0
        while ($selection -lt 1 -or $selection -gt 2) {
            $inputVal = Read-Host "`nSelect an option (1-2)"
            [int]::TryParse($inputVal, [ref]$selection) | Out-Null
        }

        if ($selection -eq 2) {
            Write-Host "`nExiting..." -ForegroundColor Yellow
            break
        }

        Write-Host "`nDownloading levels archive from GitHub..." -ForegroundColor Cyan
        Write-Host "  (Gallery: $galleryUrl)" -ForegroundColor DarkGray
        $curl = Get-Command curl.exe -ErrorAction SilentlyContinue
        if ($curl) {
            # curl.exe ships with Windows 10 1803+ and has its own fast progress meter
            & $curl.Source -L --fail --retry 3 --progress-bar -o $tempZipPath $downloadUrl
            if ($LASTEXITCODE -ne 0) { throw "curl.exe download failed (exit code $LASTEXITCODE)." }
        } else {
            # Fallback: WebClient is fast and has no progress-bar overhead
            (New-Object Net.WebClient).DownloadFile($downloadUrl, $tempZipPath)
        }

        Write-Host "Extracting..." -ForegroundColor Cyan
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [IO.Compression.ZipFile]::ExtractToDirectory($tempZipPath, $tempExtractPath)

        $innerFolder = Get-ChildItem -Path $tempExtractPath -Directory | Select-Object -First 1
        if (-not $innerFolder) { throw "Unexpected archive layout." }

        if (-not (Test-Path $levelsDir)) { New-Item -ItemType Directory -Path $levelsDir -Force | Out-Null }
        Copy-Item -Path (Join-Path $innerFolder.FullName '*') -Destination $levelsDir -Recurse -Force

        foreach ($f in $filesToClean) {
            $p = Join-Path $levelsDir $f
            if (Test-Path $p) { Remove-Item -Path $p -Force -ErrorAction SilentlyContinue }
        }

        Write-Host "`nLevels installed to: $levelsDir" -ForegroundColor Green
    } catch {
        Write-Host "`n[!] Failed: $_" -ForegroundColor Red
    } finally {
        Remove-Item -Path $tempZipPath -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $tempExtractPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host
    Read-Host "Process completed. Press Enter to return to menu..."
}
