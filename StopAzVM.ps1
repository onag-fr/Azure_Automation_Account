#######################################################################
## Set variables
#######################################################################
$subscriptionId = Get-AutomationVariable -Name 'SubscriptionId'
$tenantId = Get-AutomationVariable -Name 'TenantId'
$loggingClientID = Get-AutomationVariable -Name 'ClientId'
$loggingSecret = Get-AutomationVariable -Name 'SecretId'
$rg = Get-AutomationVariable -Name 'RGName'
$vm = Get-AutomationVariable -Name 'VmName'

#######################################################################
## Stop the VM
#######################################################################
Try {
    # Connect to Azure
    Write-Output ("Starting to authenticate to Azure")
    $secStringPassword = ConvertTo-SecureString $loggingSecret -AsPlainText -Force
    $credObject = New-Object System.Management.Automation.PSCredential ($loggingClientID, $secStringPassword)
    Connect-AzAccount -ServicePrincipal -SubscriptionId $subscriptionId -TenantId $tenantId -Credential $credObject
    Write-Output ("Authentication is completed")
} Catch {
    Write-Output ("An error occured during the Azure authentication: $($_.Exception.Message)")
}    
Try {
    #Stop the VM
    Write-Output ("Stopping the VM")
    Stop-AzVM -ResourceGroupName $rg -Name $vm -Force
    Write-Output ("The VM is stopped")
} Catch {
    Write-Output ("An error occured during the starting of the VM: $($_.Exception.Message)")
}


exit