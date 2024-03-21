resource "aws_s3_bucket" "static_web" {
  bucket = "quintet-cf-bkt"
  tags = {
    "Project"   = "Use CloudFront with s3"
    "ManagedBy" = "Quintet-NTU-Capstone-CE4-Grp3"
  }
  force_destroy = true
}

# create s3 bucket access logging -checkov-CKV_AWS_18
resource "aws_s3_bucket_logging" "access-log-bucket" {
  bucket        = aws_s3_bucket.static_web.id
  target_bucket = "quintet-log-bucket"
  target_prefix = "log/"
}

# create bucket versioning -checkov-CKV_AWS_21
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.static_web.id
  versioning_configuration {
    status = "Enabled"
  }
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
      date = "2023-12-31T00:00:00Z"
    }

    status = "Enabled"
  }


resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {

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