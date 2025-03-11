subscriptionID = "1111-111-11-11" # OVERWRITE terraform apply -var="subscriptionID=your-overridden-id"
appName = "val"
environment = "DEV"
location = "us-east"
databaseServer = {
  name     = "my-database-server"
}
