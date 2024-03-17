# List of bugs/errors encountered and its solution/fixes

1.[On 16 Mar 2024 resolved checkov=CKV_AWS_28]
2.[On 16 Mar 2024 resolved checkov=CKV2_AWS_16]
3.[On 17 Mar 2024 resolved checkov=CKV_AWS_21]
4.[On 17 Mar 2024 resolved checkov=CKV2_AWS_65]


## Error: Checkov analysis check failing upon pull request

![Checkov analysis on Terraform configurations when creating a pull request to merge to 1 branch above](/screenshots/checkov-screenshot.png)

1.[On 16 Mar 2024 checkov two issues and resolved](/screenshots/16032024-checkov-2_issues.png)
2.[On 16 Mar 2024 checkov dynamoDB autoscaling issue and resolved](/screenshots/16032024-checkov-autoScaling_issue.png)
3.[On 17 Mar 2024 checkov s3 bucket versioning issue and resouce block added](/screenshots/17032024-checkov-s3_bucket_versioning_issue.png)
4.[On 17 Mar 2024 checkov ensure access control lists for S3 buckets are disabled](/screenshots/17032024-checkov-s3_bucket_ACL_issue.png)

## Fix: Specify a "Suppressing individual checks" within the Terraform configurations for known issue

1.[On 16 Mar 2024 suppresed checkov=CKV_AWS_119]


