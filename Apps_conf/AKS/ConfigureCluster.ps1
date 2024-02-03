param(
    [Parameter(Mandatory = $True)] [string] $Region,
    [Parameter(Mandatory = $True)] [string] $Environment
)

$subscriptionId = az account show --query id --output tsv
$suffix = "-$Region$(if ([string]::IsNullOrEmpty($Environment)) { '' } else { '-' + $Environment })".ToLower()
$rgPlatform = ("RG-PLATFORM{0}" -f $suffix.ToUpper())
$kvPlatform = "ptf-kv$suffix"

# environment configuration
switch ($Environment) {
	"D" {$env = "dev"}
	"T" {$env = "test"}
    "O" {$env = "operations"}
    "I" {$env = "integration"}
}

# kubelogin setup
Write-Host " * Installing kubelogin"
az aks get-credentials --resource-group $rgPlatform --name aks-test-cluster --overwrite-existing
kubelogin convert-kubeconfig -l azurecli

#========================================================
#         clamAV AntiVirus Deployment on Cluster
#========================================================
Write-Host "  * Deploying clamAV"
Write-Host "Installing clamAV Helm Chart in $env cluster..."

helm upgrade --install clamav $PSScriptRoot/Helm/clamAV --namespace security --values $PSScriptRoot/environments/$env/clamav-values.yaml

$POD_NAME = (kubectl get pods --namespace security -l app.kubernetes.io/name=clamav -o jsonpath='{.items[0].metadata.name}')
Write-Host "Pod Name: $POD_NAME"
Start-Sleep -Seconds 240
while ($true) {
    $podStatus = kubectl get pods --namespace security $POD_NAME -o jsonpath='{.status.containerStatuses[0].ready}'
    if ($podStatus -eq "true") {
        Write-Host "Pod is in a Running state (ready)."
        break
    } elseif ($podStatus -eq "false") {
        Write-Host "Pod is not ready. Waiting..."
        Start-Sleep -Seconds 5
    } else {
        Write-Host "Pod status is unknown. Check the pod's status."
        exit 1
    }
}
Write-Host "Display Pod logs"
kubectl logs $POD_NAME 

#========================================================
#        mediawiki and mysql Deployment
#========================================================
Write-Host "  * Deploying mediawiki"

helm upgrade --install mediawiki $PSScriptRoot/Helm/mediawiki --values $PSScriptRoot/environments/$env/mediawiki-values.yaml

Write-Host "  * Deploying mariadb"
$MySQLSecretName = "mysql-Password"
$MySQLPassword = (az keyvault secret show --vault-name "sql-kv$suffix" -n $MySQLSecretName | ConvertFrom-Json).value
$MySQLRootName = "mysql-ROOT-Password"
$MySQLRootPassword = (az keyvault secret show --vault-name "sql-kv$suffix" -n $MySQLRootName | ConvertFrom-Json).value
helm upgrade --install mariadb $PSScriptRoot/Helm/mariadb --values $PSScriptRoot/environments/$env/mariadb-values.yaml --set MYSQL_ROOT_PASSWORD="$MySQLRootPassword" --set MYSQL_PASSWORD="$MySQLPassword"
