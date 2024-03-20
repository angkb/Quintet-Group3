terraform {
  backend "s3" {
    bucket = "sctp-ce4-tfstate-bucket"
    key    = "Quintet-CE4-Grp3-Capstone.tfstate"
    region = "ap-southeast-1"

    # State Locking so only 1 user during provisioning of infrastructure
    dynamodb_table = "quintet-state"
  }
}