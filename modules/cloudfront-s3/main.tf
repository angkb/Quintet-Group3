resource "aws_s3_bucket" "static_web" {

#checkov:skip=CKV2_AWS_62:This project does not need notification service
  bucket = "quintet-cf-bkt"
  tags = {
    "Project"   = "Use CloudFront with s3"
    "ManagedBy" = "Quintet-NTU-Capstone-CE4-Grp3"
  }
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.static_web.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#added bucket acl
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.static_web.id
  acl    = "private"
}

# create public access block for CKV2_AWS_6: "Ensure that S3 bucket has a Public Access block"
 resource "aws_s3_bucket_public_access_block" "static_web" {
    bucket = aws_s3_bucket.static_web.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

# encrypt bucket using SSE-S3  -checkov-CKV_AWS_145

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  policy      = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "default",
    "Statement": [
      {
        "Sid": "DefaultAllow",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::255945442255:root"
        },
        "Action": "kms:*",
        "Resource": "*"
      }
    ]
  }
POLICY
  enable_key_rotation = true
  deletion_window_in_days = 20
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.static_web.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "quintet-log-bucket1"
}

# create s3 bucket access logging -checkov-CKV_AWS_18
resource "aws_s3_bucket_logging" "access-log-bucket" {
  bucket        = aws_s3_bucket.static_web.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

# create bucket versioning -checkov-CKV_AWS_21
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.versioning_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.versioning_bucket.id

  rule {
    id = "config"

    filter {
      prefix = "config/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}



resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "quintet-versioning-bucket"
}

resource "aws_s3_bucket_ownership_controls" "versioning" {
  bucket = aws_s3_bucket.versioning_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#added bucket acl
resource "aws_s3_bucket_acl" "versioning_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.versioning]

  bucket = aws_s3_bucket.versioning_bucket.id
  acl    = "private"
}
# create bucket lifecycle configuratio -checkov-CKV_AWS_61
resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.static_web.id

  rule {
    id = "log"

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 3
    }      

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }

  rule {
    id = "tmp"

    filter {
      prefix = "tmp/"
    }

    expiration {
      days = 7
    }

    status = "Enabled"
  }

}
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {


  # logging cloudfront distribution: -checkov-CKV_AWS_86
  logging_config {
    include_cookies = false
    bucket          = "quintet-log-bucket"
    prefix          = "log"
  }

  origin_group {
    origin_id = "groupS3"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "primaryS3"
    }

    member {
      origin_id = "failoverS3"
    }
  }

  origin {
    domain_name              = aws_s3_bucket.static_web.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "origin-${aws_s3_bucket.static_web.id}"
  }

  aliases = var.aliases

  web_acl_id = var.web_acl_id

  enabled             = true
  comment             = "Static Website using S3 and Cloudfront OAC"
  default_root_object = "index.html"

  default_cache_behavior {
    cache_policy_id        = data.aws_cloudfront_cache_policy.example.id
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "origin-${aws_s3_bucket.static_web.id}"
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${aws_s3_bucket.static_web.id}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}