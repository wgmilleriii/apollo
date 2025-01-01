# PowerShell deployment script for Apollo website
$ftpUrl = "ftp://hesadoghesacow.com"
$username = "apollo1@hesadoghesacow.com"
$password = ";yT8f`$]WSnxj"
$targetPath = "/home/chipmillerme/public_html/hesadoghesacow.com"

Write-Host "Starting deployment with enhanced security..." -ForegroundColor Yellow

try {
    # Create FTP request
    $files = @(
        @{local="index.html"; remote="$targetPath/index.html"},
        @{local="death1.mp3"; remote="$targetPath/death1.mp3"}
    )

    foreach ($file in $files) {
        if (-not (Test-Path $file.local)) {
            Write-Host "Warning: $($file.local) not found in current directory" -ForegroundColor Yellow
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
            # Read file content
            $fileContent = [System.IO.File]::ReadAllBytes($file.local)
            $ftpRequest.ContentLength = $fileContent.Length

            # Get request stream and write file content
            $requestStream = $ftpRequest.GetRequestStream()
            $requestStream.Write($fileContent, 0, $fileContent.Length)
            $requestStream.Close()
            
            # Get response
            $response = $ftpRequest.GetResponse()
            Write-Host "Upload Status: $($response.StatusDescription)" -ForegroundColor Green
            $response.Close()
        }
        catch {
            Write-Host "Error uploading $($file.local): $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Full Error: $_" -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "Critical Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Full Error: $_" -ForegroundColor Red
}

Write-Host "Deployment attempt completed!" -ForegroundColor Yellow 