# This Powershell script will lookup the current pod name for qix-session and edge-auth and delete those
# (...so that they will get restarted by the deployment object ...)

$qix_sessions = kubectl get pod -o=custom-columns=NAME:.metadata.name | Select-String "qix-sessions" | Out-String
$qix_sessions = $qix_sessions.replace("`n","").replace("`r","") # remove line-breaks
Write-Host "Restarting pod $qix_sessions"
kubectl delete pod $qix_sessions

$edge_auth = kubectl get pod -o=custom-columns=NAME:.metadata.name | Select-String "edge-auth" | Out-String
$edge_auth = $edge_auth.replace("`n","").replace("`r","")  # remove line-breaks
Write-Host "Restarting pod $edge_auth"
kubectl delete pod $edge_auth
