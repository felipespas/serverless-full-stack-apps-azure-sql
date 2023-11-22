Connect-AzAccount -Tenant '16b3c013-d300-468d-ac64-7eda0820b6d3'

Get-AzSubscription

Set-AzContext -Subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

# Get resource group and location and random string
$resourceGroupName = "mslearn-serverless-app"
$resourceGroup = Get-AzResourceGroup | Where ResourceGroupName -like $resourceGroupName
$uniqueID = Get-Random -Minimum 100000 -Maximum 1000000
# $location = $resourceGroup.Location

# Azure static web app name
$webAppName = $("bus-app$($uniqueID)")

# Get the repository name
# $appRepository = Read-Host "Please enter the forked URL (for example, https://github.com/<username>/serverless-full-stack-apps-azure-sql):"

$appRepository = "https://github.com/felipespas/serverless-full-stack-apps-azure-sql"

# Get user's GitHub personal access token
# $githubToken = (Read-Host "In your GitHub account settings, near the bottom left, select Developer settings > Personal access tokens > check all boxes and generate the token. Enter the token").ToString()
$githubToken = ""

# App service plan name
# $appServicePlanName = (Get-AzAppServicePlan -resourceGroupName $resourceGroupName).Name

# Deploy Azure static web app
az staticwebapp create -n $webAppName -g $resourceGroupName `
-s $appRepository -l 'westus2' -b main --token $githubToken --app-location '/azure-static-web-app/client' --api-location '/azure-static-web-app/api/python'

az staticwebapp delete -n $webAppName -g $resourceGroupName

Write-Host "Azure Static Web App deployed."