Cls
# Define the service name and folder path
$serviceName = "MICROFOCUSOORAS_8b3a2c7d-51b2-4bc0-8968-719377cfb992"
$folderPath = "C:\Program Files\Micro Focus_New\Operations Orchestration_Mfoo\ras\var\cache"

try {
    # Check if the service is running
    $service = Get-Service -Name $serviceName -ErrorAction Stop
    
    if($service.Status -eq 'Running'){
        Stop-Service -Name $serviceName
        Set-Service -Name $serviceName -StartupType Disabled
        Start-Sleep -Seconds 15
    }

    $service = Get-Service -Name $serviceName -ErrorAction Stop

    if ($service.Status -ne 'Running') {
        Write-Host "Service '$serviceName' is stopped. Deleting cache files..."

        # Delete cache files from the specified folder
        Remove-Item -Path $folderPath\* -Force -Recurse
        # Set service startup type to Automatic
        Set-Service -Name $serviceName -StartupType Automatic
        # Restart the service
        Write-Host "Restarting service '$serviceName'..."
        Restart-Service -Name $serviceName
        Write-Host "Service '$serviceName' restarted."
        Start-Sleep -Seconds 15
    } else {
        Write-Host "Service '$serviceName' is already running."
    }
} catch {
    Write-Host "Error occurred: $_"
    if ($_.Exception.Message -like '*service not found*') {
        Write-Host "Service '$serviceName' not found."
    } elseif ($_.Exception.Message -like '*access denied*') {
        Write-Host "Access denied while trying to manage service '$serviceName'."
    } else {
        Write-Host "Unhandled exception occurred: $_"
    }
}
