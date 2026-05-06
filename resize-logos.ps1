Add-Type -AssemblyName System.Drawing

$bankDir = 'C:\Users\Vishal\StudioProjects\payflow\assets\bank'
$imageFiles = Get-ChildItem -Path $bankDir -Filter '*.png'

foreach ($file in $imageFiles) {
    try {
        $imagePath = $file.FullName
        $image = [System.Drawing.Image]::FromFile($imagePath)
        
        # Create new bitmap with 50x30 dimensions
        $resized = New-Object System.Drawing.Bitmap(50, 30)
        $graphics = [System.Drawing.Graphics]::FromImage($resized)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($image, 0, 0, 50, 30)
        
        # Save to temp file first
        $tempPath = $imagePath + '.temp'
        $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/png' }
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 95)
        
        $resized.Save($tempPath, $encoder, $encoderParams)
        
        # Cleanup
        $graphics.Dispose()
        $resized.Dispose()
        $image.Dispose()
        
        # Replace original with resized version
        Remove-Item -Path $imagePath -Force
        Rename-Item -Path $tempPath -NewName $file.Name -Force
        
        Write-Host "Resized: $($file.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "Error with $($file.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nAll bank logos resized to 50x30 pixels!" -ForegroundColor Cyan
