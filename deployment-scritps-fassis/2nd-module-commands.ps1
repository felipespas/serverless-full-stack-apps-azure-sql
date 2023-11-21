Connect-AzAccount -Tenant '16b3c013-d300-468d-ac64-7eda0820b6d3'

Get-AzSubscription

Set-AzContext -Subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

# set variables
$resourceGroupName = "mslearn-serverless-app"
$resourceGroup = Get-AzResourceGroup | Where ResourceGroupName -like $resourceGroupName
$uniqueID = Get-Random -Minimum 100000 -Maximum 1000000
$location = $resourceGroup.Location

# Azure function name
$azureFunctionName = $("azfunc$($uniqueID)")

# # Get storage account name
# $storageAccountName = (Get-AzStorageAccount -ResourceGroup $resourceGroupName).StorageAccountName
# $storageAccountName

$storageAccountName = $("storageaccount$($uniqueID)")

New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageAccountName -Location $location -SkuName Standard_GRS

# In case you want to use Python
New-AzFunctionApp -Name $azureFunctionName `
    -ResourceGroupName $resourceGroupName -StorageAccount $storageAccountName `
    -FunctionsVersion 4 -RuntimeVersion 3.9 -Runtime python -Location $location


#####################################################################

az login

# set the right subscription
az account set --subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

# Resource group name and resource group
$resourceGroupName = "mslearn-serverless-app"
$resourceGroup = Get-AzResourceGroup | Where ResourceGroupName -like $resourceGroupName
$location = $resourceGroup.Location

# # Get the repository name
# $appRepository = Read-Host "Enter your GitHub repository URL (e.g. https://github.com/[username]/serverless-full-stack-apps-azure-sql):"

# # Clone the repo - note this asks for the token
# $cloneRepository = git clone $appRepository

Set-Location "C:\_Github\serverless-full-stack-apps-azure-sql\"

# Get subscription ID 
$subId = [Regex]::Matches($resourceGroup.ResourceId, "(\/subscriptions\/)+(.*\/)+(.*\/)").Groups[2].Value
$subId = $subId.Substring(0,$subId.Length-1)

# Deploy logic app
az deployment group create --name DeployResources --resource-group $resourceGroupName `
    --template-file deployment-scripts\template.json `
    --parameters subscription_id=$subId location=$location
