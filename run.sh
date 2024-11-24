# az login
# TODO: Create a storage account to pass on the backend state to TF
# TODO: create devcenter and project
# az mdp pool create --name SH-NONPROD \
#                 --resource-group fizzbuzz \
#                 --agent-profile "Stateless={}" \
#                 --identity "type=userAssigned" "user-assigned-identities={'/subscriptions/be21f1da-36c6-4f69-9b2f-56f0a3de3cda/resourcegroups/fizzbuzz/providers/Microsoft.ManagedIdentity/userAssignedIdentities/devops-deploy-nonprod':{}}" \
#                 --location uksouth \
#                 --maximum-concurrency 2 \
#                 --organization-profile "azure-dev-ops={organizations:[{url:'https://dev.azure.com/aggieskorska',parallelism:1}],permissionProfile:{kind:'CreatorOnly'}}" \
#                 --devcenter-project-resource-id /subscriptions/be21f1da-36c6-4f69-9b2f-56f0a3de3cda/resourceGroups/fizzbuzz/providers/Microsoft.DevCenter/projects/fizzbuzz \
#                 --fabric-profile "vmss={sku:{name:Standard_D2ads_v5},storageProfile:{osDiskStorageAccountType:Standard},images:[{resourceId:'/Subscriptions/be21f1da-36c6-4f69-9b2f-56f0a3de3cda/Providers/Microsoft.Compute/Locations/eastus2/Publishers/canonical/ArtifactTypes/VMImage/Offers/0001-com-ubuntu-server-focal/Skus/20_04-lts-gen2/versions/latest',buffer:*}],osProfile:{secretsManagementSettings:{observedCertificates:[],keyExportable:false},logonType:Service}}"
# az ad sp create-for-rbac -n azdevops --role Owner --scopes /subscriptions/be21f1da-36c6-4f69-9b2f-56f0a3de3cda