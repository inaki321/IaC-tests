import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure";
import * as azure_native from "@pulumi/azure-native";

const config = new pulumi.Config();

// use the env variables 
const environment = config.require("environment");
const databaseServerName = config.require("databaseServerName");
const databaseName = config.require("databaseName");
const location = config.require("location");

// Fetch existing resource group
const resourceGroup: any = azure.core.getResourceGroup({
	name: "my-resource-group"
});

// get keyvault secrets function
const getVaultsecret = async () => {
	const example = azure.keyvault.getKeyVault({
		name: "exampleKeyVault",
		resourceGroupName: (await resourceGroup).id,
	});

	const secretVal = azure.keyvault.getSecret({
		name: "secret-sauce",
		keyVaultId: (await example).id,
	});

	return (await secretVal).value;
};

// Create SQL Server
let server: any = undefined;
const createSQLServer = async () => {
	server = new azure_native.sql.Server("server", {
		administratorLogin: "4dm1n157r470r",
		administratorLoginPassword: getVaultsecret(),
		location: location,
		publicNetworkAccess: azure_native.sql.ServerNetworkAccessFlag.Enabled,
		resourceGroupName: (await resourceGroup).name,
		serverName: `${databaseServerName} - ${environment}`,
	});
	return server;
}

const getSQLServer = async () => {
	return server;
}


// Create SQL Database
let database: any = undefined;
const createSQLDB = async () => {
	const serverResource = await getSQLServer();

	const database = new azure_native.sql.Database("database", {
		databaseName: `${databaseName} - ${environment}`,
		location: location,
		resourceGroupName: (await resourceGroup).name,
		serverName: serverResource.name,
		collation: "SQL_Latin1_General_CP1_CI_AS", // utf 8 collation (language)
		sku: {
			capacity: 2,
			family: "Gen4",
			name: "BC",
		},
		tags: {
			string: "string",
		}
	});
}
const getSQLDB = async () => {
	return database;
}



// perform run of deploy 
async function perform() {
	await createSQLServer();
	await createSQLDB();
	const serverResource = await getSQLServer();
	const databaseResource = await getSQLDB();

	const resourceGroupResource = (await resourceGroup).name
	return {
		serverResourceName: serverResource.name,
		databaseResourceName: databaseResource.id,
		resourceGroupName: resourceGroupResource.name,
	};
}

const performPromise = perform();
performPromise.catch(error => {
	console.log('error idk why ', error);
});

export const serverResourceName = performPromise.then(res => res.serverResourceName.name);
export const databaseResourceName = performPromise.then(res => res.databaseResourceName.name);
export const resourceGroupName = performPromise.then(res => res.resourceGroupName.name);