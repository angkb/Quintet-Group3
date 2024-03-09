terraform{
    backend "s3" {
      bucket = "sctp-ce4-tfstate-bucket"
      key = "VPC-s3-CE4-Grp3-Capstone.tfstate"
      region = "ap-southeast-1"
    }
}