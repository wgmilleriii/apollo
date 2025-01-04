# PowerShell deployment script for Apollo website
$ftpUrl = "ftp://hesadoghesacow.com"
$username = "apollo1@hesadoghesacow.com"
$password = ";yT8f`$]WSnxj"
$targetPath = "/home/chipmillerme/public_html/hesadoghesacow.com"

Write-Host "Starting full site deployment..." -ForegroundColor Yellow

try {
    # Create FTP request
    $files = @(
        # HTML files
        @{local="index.html"; remote="$targetPath/index.html"},
        @{local="v0.html"; remote="$targetPath/v0.html"},
        @{local="v1.html"; remote="$targetPath/v1.html"},
        @{local="v2.html"; remote="$targetPath/v2.html"},

        # Asset files
        @{local="assets/css/style.css"; remote="$targetPath/assets/css/style.css"},
        @{local="assets/js/main.js"; remote="$targetPath/assets/js/main.js"},

        # Original files
        @{local="death1.mp3"; remote="$targetPath/death1.mp3"},
        @{local="NEWSONG.txt"; remote="$targetPath/NEWSONG.txt"},

        # Folk versions
        @{local="folk/version1.mp3"; remote="$targetPath/folk/version1.mp3"},
        @{local="folk/version2.mp3"; remote="$targetPath/folk/version2.mp3"},

        # Indie versions
        @{local="indie/reggae.mp3"; remote="$targetPath/indie/reggae.mp3"},
        @{local="indie/chill.mp3"; remote="$targetPath/indie/chill.mp3"},
        @{local="indie/slow.mp3"; remote="$targetPath/indie/slow.mp3"},
        @{local="indie/bass.mp3"; remote="$targetPath/indie/bass.mp3"},

        # GWAR versions
        @{local="gwarenergetic/battle.mp3"; remote="$targetPath/gwarenergetic/battle.mp3"},
        @{local="gwarenergetic/war.mp3"; remote="$targetPath/gwarenergetic/war.mp3"},
        @{local="gwarenergetic/chaos.mp3"; remote="$targetPath/gwarenergetic/chaos.mp3"},
        @{local="gwarenergetic/prompt.txt"; remote="$targetPath/gwarenergetic/prompt.txt"}
    )

    # Create directories first
    $directories = @(
        "$targetPath/assets/css",
        "$targetPath/assets/js",
        "$targetPath/folk",
        "$targetPath/indie",
        "$targetPath/gwarenergetic"
    )

    foreach ($dir in $directories) {
        Write-Host "Creating directory: $dir" -ForegroundColor Cyan
        $uri = New-Object System.Uri("$ftpUrl$dir")
        $ftpRequest = [System.Net.FtpWebRequest]::Create($uri)
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($username, $password)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
        $ftpRequest.UseBinary = $true
        $ftpRequest.UsePassive = $true
        $ftpRequest.EnableSsl = $true
        
        try {
            $response = $ftpRequest.GetResponse()
            $response.Close()
        }
        catch {
            Write-Host "Directory might already exist: $dir" -ForegroundColor Yellow
        }
    }

    # Upload files
    foreach ($file in $files) {
        if (-not (Test-Path $file.local)) {
            Write-Host "Warning: $($file.local) not found" -ForegroundColor Yellow
            continue
        }

        Write-Host "Uploading $($file.local)..." -ForegroundColor Cyan
        
        $uri = New-Object System.Uri("$ftpUrl$($file.remote)")
        $ftpRequest = [System.Net.FtpWebRequest]::Create($uri)
        $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($username, $password)
        $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftpRequest.UseBinary = $true
        $ftpRequest.UsePassive = $true
        $ftpRequest.EnableSsl = $true
        
        try {
            $fileContent = [System.IO.File]::ReadAllBytes($file.local)
            $ftpRequest.ContentLength = $fileContent.Length

            $requestStream = $ftpRequest.GetRequestStream()
            $requestStream.Write($fileContent, 0, $fileContent.Length)
            $requestStream.Close()
            
            $response = $ftpRequest.GetResponse()
            Write-Host "Upload Status: $($response.StatusDescription)" -ForegroundColor Green
            $response.Close()
        }
        catch {
            Write-Host "Error uploading $($file.local): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "Critical Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Deployment completed!" -ForegroundColor Yellow 