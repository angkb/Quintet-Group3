resource "aws_s3_bucket" "static_web" {
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV2_AWS_6:Ensure that S3 bucket has a Public Access block
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled
 
  bucket        = "quintet-cf-bkt"
  tags = {
  "Project"   = "Use CloudFront with s3"
  "ManagedBy" = "Quintet-NTU-Capstone-CE4-Grp3"
  }
  force_destroy = true
}

#create s3 for log bucket
resource "aws_s3_bucket" "log_bucket" {
  # checkov:skip=CKV2_AWS_62:no requirement for event notifications enabled"
  # checkov:skip=CKV2_AWS_61: "No requirement for this S3 bucket to have a lifecycle configuration"
  # checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  # checkov:skip=CKV2_AWS_6: "Ensure that S3 bucket has a Public Access block"
  # checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  # checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  bucket = "quintet-logging-bucket"
}

# create s3 bucket access logging -checkov-CKV_AWS_18
resource "aws_s3_bucket_logging" "access-log-bucket" {
   bucket = aws_s3_bucket.static_web.id
   target_bucket = aws_s3_bucket.log_bucket.id
   target_prefix = "log/"
 }


# create bucket versioning -checkov-CKV_AWS_21
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.static_web.id
  versioning_configuration {
    status = "Enabled"
  }
}

# create bucket_lifecycle_configuration -checkov-CKV_AWS_61 added
resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  # checkov:skip=CKV_AWS_300: "Ensure S3 lifecycle configuration sets period for aborting failed uploads"

  bucket = aws_s3_bucket.static_web.id

  rule {
    id = "log"

    expiration {
      days = 90
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
      date = "2023-12-31T00:00:00Z"
    }

    status = "Enabled"
  }
}


  
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  #checkov:skip=CKV_AWS_86:Ensure Cloudfront distribution has Access Logging enabled
  #checkov:skip=CKV_AWS_310:Ensure CloudFront distributions should have origin failover configured
  #checkov:skip=CKV_AWS_174:Verify CloudFront Distribution Viewer Certificate is using TLS v1.2
  #checkov:skip=CKV_AWS_34:Ensure cloudfront distribution ViewerProtocolPolicy is set to HTTPS
  #checkov:skip=CKV2_AWS_32:Ensure CloudFront distribution has a response headers policy attached
  #checkov:skip=CKV2_AWS_47:Ensure AWS CloudFront attached WAFv2 WebACL is configured with AMR for Log4j Vulnerability
  #checkov:skip=CKV2_AWS_42:Ensure AWS CloudFront distribution uses custom SSL certificate
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
    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
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