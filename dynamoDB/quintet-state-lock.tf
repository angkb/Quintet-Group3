resource "aws_dynamodb_table" "terraform-lock" {
  name           = "quintet-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  
  point_in_time_recovery {
    enabled = true
  }

  #checkov:skip=CKV_AWS_119: Managed by Amazon DynamoDB

  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}