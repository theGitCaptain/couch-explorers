# DevOps Exam

## Task 1
### A. HTTP Endpoint for Lambda Function
- [Generate Image Endpoint](https://uxhce5lwq2.execute-api.eu-west-1.amazonaws.com/Prod/generate/)

### B. GitHub Actions Workflow Run
- [Workflow Run for Lambda Deployment](https://github.com/theGitCaptain/couch-explorers/actions/runs/11914701663)

---

## Task 2
### GitHub Actions Workflow Runs
- **Test Branch - Terraform Plan:** [Workflow Run](https://github.com/theGitCaptain/couch-explorers/actions/runs/11915036164)
- **Main Branch - Terraform Apply:** [Workflow Run](https://github.com/theGitCaptain/couch-explorers/actions/runs/11915188222)

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


| Task Number | Delivery Description                     | Link/Details                       |
|-------------|------------------------------------------|------------------------------------|
| Task 1      | HTTP endpoint for Lambda function        | `https://uxhce5lwq2.execute-api.eu-west-1.amazonaws.com/Prod/generate/` |
| Task 1      | GitHub Actions workflow run              | `https://github.com/theGitCaptain/couch-explorers/actions/runs/11872331862` |
| Task 2      | GitHub Actions run (Main Branch - Apply) | `https://github.com/theGitCaptain/couch-explorers/actions/runs/11896100681` |
| Task 2      | GitHub Actions run (Test Branch - Plan)  | `https://github.com/theGitCaptain/couch-explorers/actions/runs/11896414342` |
| Task 2 & 3  | SQS Queue URL                            | `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56` |
| Task 3      | Container Image Name                     | `thegitcaptain/couchexplore-client:latest` |
| Task 3      | GitHub Actions Workflow Run              | `https://github.com/theGitCaptain/couch-explorers/actions/runs/11898349911` |