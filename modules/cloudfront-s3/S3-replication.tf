## for future function

# resource "aws_s3_bucket" "static_web_replica" {
#   provider = aws.central

#   bucket = "quintet-cf-bkt-replica"
#   tags = {
#     "Project"   = "Use CloudFront with s3"
#     "ManagedBy" = "Quintet-NTU-Capstone-CE4-Grp3"
#   }
#   force_destroy = true
# }

# resource "aws_s3_bucket_versioning" "versioning_bucket_replica" {
#   provider = aws.central

#   bucket = aws_s3_bucket.static_web_replica.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_replication_configuration" "replication" {
#   provider = aws.central
#   # Must have bucket versioning enabled first
#   depends_on = [aws_s3_bucket_versioning.versioning_bucket]

#   role   = aws_iam_role.replication.arn
#   bucket = aws_s3_bucket.static_web.id

#   rule {
#     status = "Enabled"

#     destination {
#       bucket        = aws_s3_bucket.static_web_replica.arn
#       storage_class = "STANDARD"
#     }
#   }
# }