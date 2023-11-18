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