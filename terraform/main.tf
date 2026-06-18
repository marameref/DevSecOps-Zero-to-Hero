resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-demo-bucket"
}

resource "aws_s3_bucket_public_access_block" "secure_access" {
  bucket                  = aws_s3_bucket.secure_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 1. Define the Provider
provider "aws" {
  region = "us-east-1"
}

# 2. Create a Random ID for unique bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 3. Create the S3 Bucket
resource "aws_s3_bucket" "vault_test_bucket" {
  bucket = "devsecops-vault-demo-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Vault Dynamic Secret Test"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# 4. (Optional) Output the bucket name so you can see it in GitHub logs
output "bucket_name" {
  value = aws_s3_bucket.vault_test_bucket.id
}