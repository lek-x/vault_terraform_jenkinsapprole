# Creating Vault 'Approle' for Jenkins by Terraform
## Description

This code creates Vault 'Approle' for Jenkins with GitHub secrets (interactive input GitHub PAT and password).


## Requirements for creating secrets:
  - Terraform >= 1.0
  - GitHub PAT
  - GitHub pass
  - Vault Server

## Requirements for using secrets:
  - Jenkins
  - Jenkins Vault Plugin



# How to:
1. Clone repo
2. Edit variables.tf according to your preferences:
	- address of your Vault server
	- GitHub username
3. Add Vault token to **terraform.tfvars.example** and rename it to **terraform.tfvars**

4. Do next steps

Init modules:
```
terraform init
```

Check config:
```
terraform validate
```
Deploy:
```
terraform apply
```

While working, terraform will ask you to input your GitHub PAT and password. 

Then it shows you **role-id** for show **secret-id** run:

```
terraform output -json
```

# Jenkins steps:
1. Setup Vault settings in **"Manage Jenkins" - > "Configure System" - "Vault"** . Use role-id/secret-id to create  **"Vault App Role Credential"** in Jenkins.

2. Use secrets paths to create **"Vault Username-Password Credential"**:
	- secrets/creds/github_p
	- secrets/creds/github_t

3. Use **"withCredentials"** syntax to use secrets in pipeline




## License
GNU GPL v3