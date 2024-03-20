# tf-gcp-infra
Infra setup for web application on GCP using IaC tool Terraform

- Project name:  
CSYE6225-eashan-roy 
  
- GCP Service APIs enabled:  
Compute Engine API  
Cloud Monitoring API  
Cloud Logging API  
Cloud DNS API  
Service Networking API  

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
Compute Network  
Public subnet (for web application)  
Private subnet (for database) 
Compute engine (VM)  
Route (to Internet Gateway for web application)  
CloudSQL instance, CloudSQL database, ClouSQL user  
Service account for VM  
DNS A record  

- GitHub Actions workflow  
CI workflow to format and validate terraform code before PR can be merged to organization repo's main branch