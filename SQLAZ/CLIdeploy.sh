az login
az account set --subscription "your-subscription-id"

# fetch the secret 
sql_password=$(az keyvault secret show --name sqlserver-password-DEV --vault-name exampleKeyVault --query value -o tsv)


# check for my group (or list the groups or create it )
az group exists --myResourceGroup

az sql server create --name mySqlServer --resource-group myResourceGroup --location eastus --admin-user 4dm1n157r470r --admin-password $sql_password


az sql db create --resource-group myResourceGroup --server mySqlServer --name myDatabase --service-objective S0 --max-size 2GB --collation SQL_Latin1_General_CP1_CI_AS


# example using firewall (only access by specific IP addresses)
az sql server firewall-rule create --resource-group myResourceGroup --server mySqlServer --name AllowRange --start-ip-address <start-ip-address> --end-ip-address <end-ip-address>

