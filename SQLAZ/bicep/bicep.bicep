// Define parameters
param databaseServerName string = 'my-database-server'
param environment string
param resourceGroupName string = 'my-resource-group'
param keyVaultName string = 'exampleKeyVault'
param sqlAdminLogin string = '4dm1n157r470r'
param appName string

// Fetch the existing resource group
resource myResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

// Fetch the Key Vault
resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-04-01' existing = {
  name: keyVaultName
  scope: myResourceGroup
}

// Fetch the secret from the Key Vault
resource sqlserverPassword 'Microsoft.KeyVault/vaults/secrets@2021-04-01' existing = {
  parent: keyVaultResource
  name: 'sqlserver-password-DEV'
}

// Define the SQL Server resource
resource mysqlserver 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: '${databaseServerName}-sqlserver-${environment}'
  location: myResourceGroup.location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlserverPassword.properties.value
    version: '12.0'
  }
  tags: {
    foo: 'needed tags'
  }
}

// Define the SQL Database resource
resource mysqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: mysqlserver
  name: '${databaseServerName}/${appName}-sqldb-${environment}'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    licenseType: 'LicenseIncluded'
    maxSizeBytes: 2 * 1024 * 1024 * 1024 // 2 GB
    sku: {
      name: 'S0'
    }
    zoneRedundant: false //NO Replication multi regions
    readScale: 'Disabled'//No replicas 
    autoPauseDelay: -1
    minCapacity: 0 // no min capacity 
    readReplicaCount: 0 //# of replicas
    highAvailabilityReplicaCount: 0
    createMode: 'Default'
    storageAccountType: 'GRS' // Geo standard
    requestedBackupStorageRedundancy: 'Geo'
  }
  tags: {
    foo: 'needed tags'
  }
  // Note: Bicep does not have a direct equivalent of Terraform's lifecycle.prevent_destroy
  // You can manage this through Azure Policy or manual governance
}
