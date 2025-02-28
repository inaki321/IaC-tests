# create my secret in keyvault for my server pass
az keyvault create --name "exampleKeyVault" --resource-group "resource-group-name" --location "eastus"
az keyvault secret set --vault-name "exampleKeyVault" --name "sqlserver-password-DEV" --value "4-v3ry-53cr37-p455w0rd"

# WEB UI (no access)
# https://www.youtube.com/watch?v=r_StkzGWXiI
