# for future function
provider "aws" {
  alias  = "central"
  region = "eu-central-1"
}


resource "aws_s3_bucket" "static_web_replica" {
  provider = aws.central

  bucket = "quintet-cf-bkt-replica"
  tags = {
    "Project"   = "Use CloudFront with s3"
    "ManagedBy" = "Quintet-NTU-Capstone-CE4-Grp3"
  }
  force_destroy = true
}

resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-replication-12345"
  assume_role_policy = data.aws_iam_policy_document.default.json
}



resource "aws_s3_bucket_versioning" "versioning_bucket_replica" {
  provider = aws.central

  bucket = aws_s3_bucket.static_web_replica.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.central
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.static_web.id

  rule {
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.static_web_replica.arn
      storage_class = "STANDARD"
    }
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]

    resources = [aws_s3_bucket.static_web.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]

    resources = ["${aws_s3_bucket.static_web.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]

    resources = ["${aws_s3_bucket.static_web_replica.arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "tf-iam-role-policy-replication-12345"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}