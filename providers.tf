provider "aws" {
  region = "us-east-1"  # required — the only mandatory argument

  # Optional: static credentials (prefer env vars or IAM roles instead)
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key

  # Optional: use a named profile from ~/.aws/credentials
  # profile = "my-profile"

  # Optional: assume a role before making API calls
  # assume_role {
  #   role_arn = "arn:aws:iam::123456789012:role/MyRole"
  # }

  default_tags {
    tags = {
      ManagedBy   = "opentofu"
      Environment = "dev"
    }
  }
}