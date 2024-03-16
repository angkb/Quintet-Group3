# List of bugs/errors encountered and its solution/fixes

[On 16 Mar 2024 resolved checkov=CKV_AWS_28]
[On 16 Mar 2024 resolved checkov=CKV2_AWS_16]

## Error: Checkov analysis check failing upon pull request

![Checkov analysis on Terraform configurations when creating a pull request to merge to 1 branch above](/screenshots/checkov-screenshot.png)

![On 16 Mar 2024 checkov two issues and resolved](/screenshots/16032024-checkov-2_issues.png)
![On 16 Mar 2024 checkov dynamoDB autoscaling issue and resolved](/screenshots/16032024-checkov-autoScaling_issue.png)

## Fix: Specify a "Suppressing individual checks" within the Terraform configurations for known issue

[On 16 Mar 2024 suppresed checkov=CKV_AWS_119]


