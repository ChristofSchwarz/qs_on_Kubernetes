# This Powershell will call "kubectl delete pod" for a given list of pods
# (...typically after deletion they will be restarted by the deployment object ...)
# Provide the list pipe-separated 
# Each entry is matched as "pod name >contains< entry", not the exact name

$podlist = "qix-sessions|edge-auth"  
Write-Host "Deleting pods" 
Write-Host $podlist.replace("|","`n")
$getpods = kubectl get pod -o=custom-columns=n:.metadata.name | Select-String "(?:$podlist)" 
ForEach ($pod in ($getpods -split ("`r") -split ("`n")))
{
    If ($pod.length -gt 0) { kubectl delete pod $pod }
}

