# promoes-infrastructure
Provision Promoes infrastructure onto Google Cloud Platform

## Setup
1. Create Google Cloud Service Account under IAM & Admin module of Promoes project.
   ```
   gcloud iam service-accounts create terraform \
   --display-name="Terraform default service account"
   ```
2. Enable Enable Service Networking API.
   ```
   gcloud services enable servicenetworking.googleapis.com \
    --project=promoes
   ```
3. Grant Project Editor role to the service account.
   ```
   gcloud projects add-iam-policy-binding promoes \
    --member=serviceAccount:terraform@promoes.iam.gserviceaccount.com --role=roles/editor
   ```
4. Generate a JSON key file of the service account.
   ```
   gcloud iam service-accounts keys create tf-private-key.json \
   --iam-account=terraform@promoes.iam.gserviceaccount.com
   ```
5. Supply the key to Terraform using the environment variable.
   ```
   export GOOGLE_APPLICATION_CREDENTIALS=tf-private-key.json
   ```
6. Initialize Terraform.
   ```
   terraform init
   ```
7. Apply Terraform.
   ```
   terraform apply
   ```
