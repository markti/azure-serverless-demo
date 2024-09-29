# Welcome

This codebase is a sample solution from the book [Mastering Terraform](https://amzn.to/3XNjHhx). This codebase is the solution from Chapter 12 where Soze Enterprises is deploying their solution with Serverless using Azure Functions. It includes infrastructure as code (IaC) using Terraform.

## Terraform Code

The Terraform code is stored in `src\terraform`. There is only one root module and it resides within this directory. There is only the default input variables value file `terraform.tfvars` that is loaded by default.

You may need to change the `primary_region` input variable value if you wish to deploy to a different region. The default is `westus2`.

If you want to provision more than one environment you may need to remove the `environment_name` input variable value and specify an additional environment `tfvar` file.

## GitHub Actions Workflows

### Terraform Workflows
The directory `.github/workflows/` contains GitHub Actions workflows that implement a CI/CD solution using Packer and Terraform. There are individual workflows for the three Terraform core workflow operations `plan`, `apply`, and `destroy`.

# Pre-Requisites

## Entra Setup

In order for GitHub Actions workflows to execute you need to have an identity that they can use to access Azure. Therefore you need to setup a new App Registration in Entra for Terraform. In addition, you should create a Client Secret to be used to authenticate.

The Entra App Registration's Application ID (i.e., the Client ID) needs to be set as Environment Variables in GitHub.

The App Registration should have it's Application ID stored in a GitHub environment Variable `TERRAFORM_ARM_CLIENT_ID` and it's client Secret stored in `TERRAFORM_ARM_CLIENT_SECRET`.

## Azure Setup

### App Registration Subscription Role Assignments

The Entra App Registration created in the previous step need to be granted `Owner` access to your Azure Subscription.

### Azure Storage Account for Terraform State

Lastly you need to setup an Azure Storage Account that can be used to store Terraform State. You need to create an Azure Resource Group called `rg-terraform-state` and an Azure Storage Account within this resource group called `ststate00000`. replace the five (5) zeros (i.e., `00000`) with a five (5) digit random number. Then inside the Azure Storage Account create a Blob Storage Container called `tfstate`.

The Resource Group Name, the Storage Account Name and the Blob Storage container Name will be used in the GitHub Configuration.

### GitHub Configuration

You need to add the following environment variables:

- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID
- TERRAFORM_ARM_CLIENT_ID
- BACKEND_RESOURCE_GROUP_NAME
- BACKEND_STORAGE_ACCOUNT_NAME
- BACKEND_STORAGE_CONTAINER_NAME

You need to add the following secrets:

- TERRAFORM_ARM_CLIENT_SECRET