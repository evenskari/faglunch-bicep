# az login
# az account set --subscription f3d0ada3-bf24-4081-adb6-824027ca841c (NOVA-POINTTAKEN)

# Call with dot sourcing operator (.) to make sure the variables are available in the current scope after execution

# . .\deploy.ps1 -projectName faglunchbicep -env dev -location westeurope -customerName pt

param (
    [string]$projectName,
    [string]$env,
    [string]$location,
    [string]$customerName
)

az --version
$rg = az group create --name "rg-$customerName-$projectName-$($env.substring(0,1))" --location westeurope

$deployment = az deployment group create `
    --resource-group ($rg | ConvertFrom-Json).Name `
    --template-file ./main.bicep `
    --parameters env=$env projectName=$projectName customerName=$customerName #`
    # --parameters "./main.secretParameters.$env.json" `

# Debug output from module
$deployment | Format-List
$deploymentObject = $deployment | ConvertFrom-Json
$outputs = $deploymentObject.properties.outputs
Write-Host ($outputs | Format-Table | Out-String)
Write-Host "storageAccountName=$($outputs.storageAccountName.value)"
# Outputs to be used in other jobs
Write-Host "##vso[task.setvariable variable=storageAccountName;isOutput=true]$($outputs.storageAccountName.value)"

#Copy 
# $projectName = 'azkontroll'
# $customerName = 'pt'
# $env ='dev'
# $rg = az group create --name "rg-$customerName-$projectName-$($env.substring(0,1))" --location westeurope

# $deployment = az deployment group create `
#     --resource-group ($rg | ConvertFrom-Json).Name `
#     --template-file ./main.bicep `
#     --parameters env=$env projectName=$projectName customerName=$customerName #`
#     # --parameters "./main.secretParameters.$env.json" `

# $output = $($deployment | ConvertFrom-Json).properties.output
# Write-Host "Output from module: $output"
