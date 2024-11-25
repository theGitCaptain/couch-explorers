# DevOps Exam

## Task 1
### A. HTTP Endpoint for Lambda Function
- `https://ar4yl99c6b.execute-api.eu-west-1.amazonaws.com/Prod/generate`

### B. GitHub Actions Workflow Run
- `https://github.com/theGitCaptain/couch-explorers/actions/runs/12012521344`

---

## Task 2
### GitHub Actions Workflow Runs
- **Test Branch - Terraform Plan:** `https://github.com/theGitCaptain/couch-explorers/actions/runs/12019599618`
- **Main Branch - Terraform Apply:** `https://github.com/theGitCaptain/couch-explorers/actions/runs/12013066204`

### SQS Queue URL
- `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56`

---

## Task 3
### Description of Tagging Strategy
I ended up going for a hybrid tagging strategy that uses both timestamps and a latest tag. A timestamp-based tag for every image to ensure each build is unique and traceable, and a latest tag for convenience, so it's easy for developers to quickly pull the most recent image.

The approach is practical for automation, as the timestamp tags are generated dynamically during the CI/CD process. It also ensures traceability and keeps things simple for frequent builds. The latest tag makes it easy to access the most recent image, which is ideal for active development.

### Container Image
- `thegitcaptain/couchexplore-client:latest`
- `thegitcaptain/couchexplore-client:20241119.141119`

### SQS Queue URL
- `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56`


## Task 4
### Alarm
The task did not ask for any specific delivery, but I chose to set the trigger for the alarm to 60 seconds. I made a terraform.tfvars file for entering the email, and just set it to a default email after testing that the alarm worked with my own email.

### Cloudwatch Alarm  URL
- `https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#alarmsV2:alarm/sqs-age-of-oldest-message-alarm-56?~(search~'56)

## Task 5


| Task Number | Delivery Description                     | Link/Details                       |
|-------------|------------------------------------------|------------------------------------|
| Task 1      | HTTP endpoint for Lambda function        | `https://ar4yl99c6b.execute-api.eu-west-1.amazonaws.com/Prod/generate` |
| Task 1      | GitHub Actions workflow run              | `https://github.com/theGitCaptain/couch-explorers/actions/runs/12012521344` |
| Task 2      | GitHub Actions run (Test Branch - Plan)  | `https://github.com/theGitCaptain/couch-explorers/actions/runs/11915036164` |
| Task 2      | GitHub Actions run (Main Branch - Apply) | `https://github.com/theGitCaptain/couch-explorers/actions/runs/12013066204` |
| Task 2      | SQS Queue URL                            | `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56` |
| Task 3      | Container Image Name                     | `thegitcaptain/couchexplore-client:latest` |