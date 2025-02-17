# Ask the user to choose between Full hard delete or Soft delete
Write-Host "Choose an option:"
Write-Host "1) Full hard delete"
Write-Host "2) Soft delete (plugins only)"
$choice = Read-Host "Enter your choice (1 or 2)"

# Execute based on user's choice
switch ($choice) {
    "1" {
        Write-Host "Running Full hard delete..."
        cd D:\Projects\Catfish
        .\Build-Catfish.bat hardcoreclean
    }
    "2" {
        Write-Host "Running Soft delete (deleting plugins only)..."
        $pluginsPath = "D:\Projects\catfish\Catfish\Presentation\Nop.Web\Plugins"

        if (Test-Path $pluginsPath) {
            Remove-Item "$pluginsPath\*" -Recurse -Force
            Write-Host "All plugins in the folder have been deleted."
        } else {
            Write-Host "The plugins folder does not exist: $pluginsPath"
        }
    }
    default {
        Write-Host "Invalid choice. Please run the script again and choose 1 or 2."
    }
}