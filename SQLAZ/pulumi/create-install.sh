# install pulumi (I use MacOs)
brew install pulumi/tap/pulumi
pulumi version


#az login 
#az account show
#az account set --subscription "<subscription-id-or-name>"


mkdir test-pulumi
cd test-pulumi
pulumi new typescript -y --name pulumi-azure-mssql
yarn add @pulumi/azure
yarn add @pulumi/azure-native # install azure package 


# set env variables 
pulumi config set environment dev
pulumi config set databaseServerName myDatabaseServer
pulumi config set databaseName mydatabaseName
pulumi config set location us-west
pulumi config set azure:subscriptionId 00000000-0000-0000-0000-0000000000
pulumi config set azure-native:subscriptionId 00000000-0000-0000-0000-0000000000


# documentation is as good as terraform documentation
# you can just search what you need and start building 
# like pulumi azure get keyvault , pulumi azure get keyvault secret 
# pulumi azure sql server etc.


# Every Pulumi program is deployed to a stack. A stack is an isolated, independently configurable instance of a Pulumi program
# like TF backend
# pulumi stack

# pulumi stack rm <stack-name> # remove stack (create project with same name, remove backend etc)
# pulumi stack rm inaki321/pulumi-azure-mssql-v2/dev # remove stacks from cloud
# pulumi stack select dev # switch stacks


#pulumi up # deploy
# pulumi preview 
# pulumi destroy

