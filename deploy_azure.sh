#!/bin/bash

# Set variables
RESOURCE_GROUP="cloud-job-quiz-rg"
LOCATION="eastus"
ACR_NAME="cloudjobquizacr"
CONTAINER_APP_NAME="cloud-job-quiz-api"
POSTGRES_SERVER="cloudjobquizdb"
POSTGRES_ADMIN="myadmin"
POSTGRES_PASSWORD="MySecurePassword123!"
POSTGRES_DB="quizdb"
IMAGE_NAME="cloud-job-quiz-api"
IMAGE_TAG="latest"

# Step 1: Create Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Step 2: Create Azure Container Registry (ACR)
az acr create --name $ACR_NAME --resource-group $RESOURCE_GROUP --sku Basic --admin-enabled true

# Step 3: Login to ACR
az acr login --name $ACR_NAME

# Step 4: Build and Push Docker Image to ACR
docker build -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG .
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

# Step 5: Create Azure Database for PostgreSQL
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name $POSTGRES_SERVER \
  --admin-user $POSTGRES_ADMIN \
  --admin-password $POSTGRES_PASSWORD \
  --sku-name B_Standard_B1ms

# Get PostgreSQL connection string
DATABASE_URL="postgresql://$POSTGRES_ADMIN:$POSTGRES_PASSWORD@$POSTGRES_SERVER.postgres.database.azure.com:5432/$POSTGRES_DB"

# Step 6: Create Azure Container App
az containerapp create \
  --name $CONTAINER_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --image $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG \
  --environment-variables DATABASE_URL=$DATABASE_URL \
  --target-port 8000 \
  --ingress external
