variable "subscriptionID" {
  description = "The name of my sql application"
  type        = string
}

variable "appName" {
  description = "The name of my sql application"
  type        = string
}

variable "location" {
  description = "Location of the AZ resource"
  type        = string
}

variable "environment" {
  description = "Application environment (DEV, Non-prod, prod etc.)"
  type        = string
}

variable "databaseServer" {
  description = "The hosted zone for the domain"
  type        = string
}

variable "databaseServer" {
  description = "Configuration for the database server"
  type = object({
    name     = string
  })
}
