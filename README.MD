#### ECS Cluster with Fargate
This is a simple demo, to run a webapp on ecs with fargate, for brevity, the infra uses 
default vpc and public subnet. 
Workload, The [my-app](https://github.com/naveenrajkumar/my-app) repo, is the java app which prints the version of git-sha to deploy to ECS

##### Deployment

###### ECR creation and Docker image upload
```sh
./ecr/terraform apply  - to create ecr repository
docker pull nvnraj/my-app
docker tag my-app:latest 034818602755.dkr.ecr.ap-southeast-2.amazonaws.com/my-app:latest
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 034818602755.dkr.ecr.ap-southeast-2.amazonaws.com
docker push 034818602755.dkr.ecr.ap-southeast-2.amazonaws.com/my-app:latest
```

###### ECS creation with fargate
```sh
./ecs/terraform init
./ecs/terraform apply -var 'image_url=034818602755.dkr.ecr.ap-southeast-2.amazonaws.com/my-app:latest'
```

##### Output
[http://my-app-lb-tf-1301411410.ap-southeast-2.elb.amazonaws.com/version](http://my-app-lb-tf-1301411410.ap-southeast-2.elb.amazonaws.com/version)
{"myapplicaiton":{"lastcommitsha":"3aba5d184e1c550f3e0c8bdc08a19657eff56cba1.0.0","description":"pre-interview technical test","version":"1.0.0"}}

#####  Testing Approach - 
* Unit, component and blackbox testing : Goes as a pyramid structure, unit test as maximum coverage with progressively diminishing component and blackbox testing.
* The tooling needs to be developed for developer experience for static code analysis, PMD checks.
* Security testing happens as part of each CI build.
* CD - Deploys the vetted artifact to staging followed by production, with necessary tvt testing

#### Production Planning

For production work load, the following architecture can be considered.

* Security - Deploying in private subnets, Web Application Firewall, Protection through security groups and NACL, cloud front to respond for DDOS attack
* Availablility - Tasks, ALB, Nat Gateway Deployed in muliple availability zone, auto scaling of tasks based on cloud watch.
* Operations - WIth ECS Fargate, there is no servers here to manage and patch, Observablity and logging need to built in to the app. Cloud watch logs and dashboard should help. Neccesary alert via cloud watch alerts.
* Developer Experience - Necessary tooling need to be built, so that most of the feedback is provided pretty quick in the developer environment. The code needs to fail fast with necessary test coverage.

![ECS](https://github.com/naveenrajkumar/ecs/blob/master/ecs.png)