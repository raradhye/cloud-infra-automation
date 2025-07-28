# Cloud Infrastructure Automation with Terraform and GitHub Actions

This project demonstrates automated provisioning of Azure infrastructure using **Terraform** and **GitHub Actions** for CI/CD workflows.

---

## 💡 Key Features

- 🚀 Provision Azure App Service using Terraform  
- 🔄 Automate infrastructure deployment with GitHub Actions  
- 🔐 Secure authentication using Azure AD Service Principal  
- 💾 Use Azure Storage Account for remote Terraform state  
- ✅ Integrated security and compliance scanning with **Checkov**  

---

## 📦 Prerequisites

Before running this demo, you’ll need:

- An **Azure subscription**
- An **Azure AD Service Principal** with Contributor permissions  
- An **Azure Storage Account** and blob container  
- A **GitHub account** with a forked copy of this repo  
- A **GitHub Personal Access Token (PAT)**  

---

## ⚙️ Setup: Azure Resources & GitHub Secrets

Terraform needs credentials to provision Azure resources. Since GitHub Actions runs on ephemeral runners, we use:

- **Azure Service Principal** for authentication  
- **GitHub secrets** to store sensitive values  
- **Azure Blob Storage** for remote Terraform state  

The `remote_setup/` directory automates the creation of:

- Azure Storage Account and container  
- Azure Service Principal with Contributor rights  
- GitHub repository secrets  

### 🔑 Create GitHub PAT  
Follow [these instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to generate a PAT. Save it temporarily to an environment variable:

```bash
# Replace with your token
export GITHUB_TOKEN=your_pat_here
```

---

## 🚀 Running the Setup

From the project root, execute:

```bash
# Log into Azure and set the subscription
az login
az account set --subscription "YOUR_SUBSCRIPTION_NAME"

# Enter the setup directory
cd remote_setup

# Initialize and apply Terraform
terraform init
terraform apply -auto-approve
```

> 🔁 If your repository name is different, add:  
> `-var=github_repository=your_repo_name`

---

## 🛠 GitHub Actions Workflow

GitHub Actions are triggered by `push` or `pull_request` events. The pipeline performs:

### On All Events
- Check out the repository code
- Install Terraform  
- Initialize with remote backend  
- Format check (`terraform fmt`)  

### On PRs or Pushes to Non-Main Branches
- Run `terraform validate`  
- Plan infrastructure changes  
- Run **Checkov** for security and compliance checks  
- Comment results on the PR  

### On Push to Main Branch (Merge)
- Auto-approve and apply infrastructure changes  

---

## 🧹 Cleanup

To clean up:

1. **Delete deployed App Service** via Azure Portal or CLI  
2. Remove or disable GitHub Actions (`.github/workflows/terraform.yml`)  
3. From `remote_setup/`:
   ```bash
   terraform destroy
   ```

---

## 🧾 Notes

- This project is built for educational/demo purposes but follows **production-grade patterns** like remote state, security scanning, and CI/CD automation.  
- All infrastructure changes are managed via **pull requests** and **Terraform plans** to ensure safe deployments.

---