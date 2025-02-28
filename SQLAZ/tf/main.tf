provider "azurerm" {
  features {}
}

# fetch my resource group and key vault secret (fetch location, secret, name, data)
data "azurerm_resource_group" "myresource-group" {
  name = "my-resource-group"
}

data "azurerm_key_vault" "keyVaultResource" {
  name                = "exampleKeyVault"
  resource_group_name = "resource-group-name"
}

data "azurerm_key_vault_secret" "sqlserver-password" {
  name         = "sqlserver-password-DEV"
  key_vault_id = data.azurerm_key_vault.keyVaultResource.id
}

# create server and database
resource "azurerm_mssql_server" "mysqlserver" {
  name                         = "${var.databaseServer.name}-sqlserver-${var.environment}"
  resource_group_name          = azurerm_resource_group.myresource-group.name
  location                     = azurerm_resource_group.myresource-group.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = data.azurerm_key_vault_secret.sqlserver-password.value
}

resource "azurerm_mssql_database" "mysql-atabase" {
  name         = "${var.databaseServer.name}/${var.appName}-sqldb-${var.environment}"
  server_id    = azurerm_mssql_server.mysqlserver.id
  collation    = "SQL_Latin1_General_CP1_CI_AS" # utf 8 collation (language)
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS" # or "SGX" for Intel SGX enclaves

  tags = {
    foo = "needed tags"
  }

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}
