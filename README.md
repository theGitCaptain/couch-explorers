# DevOps Exam

## Task 1
### A. HTTP Endpoint for Lambda Function
- `https://ar4yl99c6b.execute-api.eu-west-1.amazonaws.com/Prod/generate`

### B. GitHub Actions Workflow Run
- `https://github.com/theGitCaptain/couch-explorers/actions/runs/12012521344`

---

## Task 2
### GitHub Actions Workflow Runs
- **Test Branch - Terraform Plan:** `https://github.com/theGitCaptain/couch-explorers/actions/runs/12020150120`
- **Main Branch - Terraform Apply:** `https://github.com/theGitCaptain/couch-explorers/actions/runs/12020164006`

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

### GitHub Actions Workflow (Not specified as delivery)
- `https://github.com/theGitCaptain/couch-explorers/actions/runs/12020840108`


## Task 4
### Alarm
The task did not ask for any specific delivery, but I chose to set the trigger for the alarm to 60 seconds. I made a terraform.tfvars file for entering the email, and just set it to a default email after testing that the alarm worked with my own email.

### Cloudwatch Alarm  URL
- `https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#alarmsV2:alarm/sqs-age-of-oldest-message-alarm-56?~(search~'56)`

## Task 5
### 1. Automation and continuous delivery (CI/CD)
With a serverless architecture, the focus shifts to deploying individual functions, each with their own lifecycle. A serverless architecture has the advantage of smaller, independent deployments, which allows for faster rollouts of cahnges and isolation of specific components. CI/CD services that integrate seamlessly with AWS Lambda enables straightforward automation for deployment of individual functions.

However, the serverless approach is also a bit more complex in terms of managing the lifecycle of many smaller components, where each function may require separate versioning, which can lead to a fragmented deployment process if not handled carefully.

On the other hand, microservice-based architectures package entire services into containers. CI/CD pipelines for microservices are often centralized. The focus is on building, testing and deploying a service at a time, which simplifies deployment because we treat each service as a single unit. But this also makes it so that even with tiny adjustments or changes in the code, you have to redeploy the entire container, which can be slow and less efficient than serverless rollouts.

Therefore, serverless architectures align well with automation because it reduces infrastructure management and enables faster updates. However, they also demand robust tooling and careful planning to manage the increased number of components. Microservices on the other hand, offer consistency and simplicity in CI/CD pipelines, but may not be as agile and granular as the serverless solutions.

### 2. Observability (Monitoring)
When transitioning from a microservice-based architecture to a serverless one, observability changes a bit due to the differences in how the systems are structured and operate. In a microservice-based architecture, the monitoring is often centralized, and focuses on services as discrete units. We use tools that tracks metrics, logs and traces across containers. The good thing about that is that it makes it easier to maintain end-to-end visibility, and we keep issues within a service. Service-level tracing is straightforward, and less complex when for debugging.

In contrsat, a serverless architecture has different challenges. Each function operates independently, and logs and metrics are often distributed across multiple functions. While we do have integrated tools in AWS, such as CloudWatch logs and AWS X-Ray, correlating logs and traces across several Lambda functions is more complex and requires extra effort. For example, debugging a serverless workflow may involve tracing one single transaction across several functions and services, which can be significantly more complex than in a microservice architecture. 

Another challenge is with cold starts, where function take longer to initialize if we have not invoked them recently, which can impact performance.

Although there are challenges, serverless architectures offer very deep insights into performance and metrics at the function level. Developers can monitor specific invocations, execution durations and error rates for each function. But with so many logs and metrics from many functions it can be quite overwhelming without good aggregation tools.

So: Microserviecs provide centralized and simpler debugging, while serverless architectures can give you way more insight but can also be overwhelming without the proper tools and processes to distribute logs and traces.

### 3. Scalability and Cost Control
Serverless and microservice archtiectures both have different approaches to scalability and cost control, both with their pros and cons.

In a serverless architecture scalability is automatic. AWS Lambda for example, handles scaling for you by automatically spinning up additional instances of your functions based on demand. This makes serverless ideal for workloads when you have unpredictable traffic, as it eliminates the need to manage resources manually. Additionally you only pay for what you use: The cost is based on the number of requests and the execution time of the functions. This can make serverless very cost-efficient. It can also lead to unexepectedly high costs if you suddenly have an unexpected spike of traffic.

A downside with serverless is again the issue of cold starts, as mentioned on the last point about observability and monitoring. When you have not used a Lambda function for a while, it takes longer to start up. For applications with strict performance requirements, it can be a problem. Also, while serverless is very cost-efficient for smaller workloads, it could get expensive at very high scales compared to other options. 

In a microservice architecture, you have more control of the scalability. You can use tools to set up auto-scaling policies to handle traffic spikes, although it does require a bit more configuration and management. The costs are more predictable though, because you pay for the resources you provision, fully utilized or not. So based on this, microservices is a better choice for steady and predictable workloads as you can have more fine-tuned control. The drawback is obviously that you can waste resources when you have low traffic, as you still pay for the idle capacity, which can make resoucre utilization less efficient compared to serverless. However, since you control the infrastructure, you can fine-tune scaling strategies to optimize costs at larger scales. 

So serverless is great for automatic scaling and cost efficiency at low or unpredictable traffic, but it can get expensive at high volumes and is affected by cold starts. Microservices offer predictable costs and fine-tuned control over scaling but it can be inefficient for more unstable workloads and requires more effort to manage scaling as well.

### 4. Ownership and responsibility
Switching from a microservice based architecture to a serverless one also impacts the DevOps team's ownership and responsibility in several ways.

When you have a serverless architecture, a lot of the infrastructure management is handled by the cloud provider, for example AWS. This reduces the team's own responsibility fo things like scaling, patching and managing servers, and allows more focus on application logic and business needs rather than worrying about maintaining the infrastructure. For performance and reliability, the cloud provider ensures high availability and scales the functions automatically. The team is still responsible for ensuring that the functions are well optimized in order to minimize costs and prevent inefficiencies though. 

With serverless we also get new responsibilities. When you have so many small and independent functions the team has to manage the lifecycle of each function, including versioning, testing and deployment. Monitoring and debugging is also more challenging then because there are more components to keep track of, which can make isolating issues more difficult. You must also monitor costs carefully, because the pay-per-use model can result in unexpected bills if the workload isnt designed properly. 

In a microservice architecture, the DevOps team has more control over the infrastructure. They are responsible for provisioning and managing servers and containers, configuring scaling policies and to ensure reliability. This is great in the way that it gives them full ownership over the system's performance, but also requires more work. For example, you need to handle the patching, updates and scaling manually. But you do also have greater visiblity and control over the system, which can make it easier to optimize and debug compared to a serverless architecture.

So it comes down to control and complexity. With serverless architectures, the team's responsibility in many areas shift over to the cloud provider, but you have to handle the challenges that comes with working with many small components. And with microservices, you have full control but you must also manage the infrastructure and scaling yourself.



## Deliveries Table


| Task Number | Delivery Description                     | Link/Details                       |
|-------------|------------------------------------------|------------------------------------|
| Task 1      | HTTP endpoint for Lambda function        | `https://ar4yl99c6b.execute-api.eu-west-1.amazonaws.com/Prod/generate` |
| Task 1      | GitHub Actions workflow run              | `https://github.com/theGitCaptain/couch-explorers/actions/runs/12012521344` |
| Task 2      | GitHub Actions run (Test Branch - Plan)  | `https://github.com/theGitCaptain/couch-explorers/actions/runs/12020150120` |
| Task 2      | GitHub Actions run (Main Branch - Apply) | `https://github.com/theGitCaptain/couch-explorers/actions/runs/12020164006` |
| Task 2      | SQS Queue URL                            | `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56` |
| Task 3      | Container Image Name                     | `thegitcaptain/couchexplore-client:latest` / `thegitcaptain/couchexplore-client:20241119.141119` |
| Task 3      | SQS Queue URL                            | `https://sqs.eu-west-1.amazonaws.com/244530008913/image-generation-queue-56` |