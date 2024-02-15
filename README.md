# tf-gcp-infra
Infra setup for web application on GCP using IaC tool Terraform

- Project name:  
CSYE6225-eashan-roy 
  
- GCP Service APIs enabled:  
Compute Engine API  

- CLI setup:  
gcloud auth login   
gcloud auth application-default login  
gcloud config set project csye6225-eashan-roy  

- Terraform commands:  
terraform init  
terraform fmt
terraform validate  
terraform plan  
terraform apply  
terraform destroy  

- Infra setup  
1 Compute Network  
1 public subnet (for web application)  
1 private subnet (for database)  
1 route (to Internet Gateway for web application)  

- GitHub Actions workflow  
CI workflow to format and validate terraform code before PR can be merged to organization repo's main branch