# DevSecOps
## _Capstone Project, Grp 3 (Quintet)_ 
### _Date: 23 Mar 2024_
### _Author(s):_
- Ang Kok Beng
- Joseph Ong
- Lim Wei Jie
- Muhammad Rudyn
- Sagar Ingale
____________________________________________________________
## _Introduction_
This README.md details the implementation of a DevSecOps approach for the project. It outlines the methodologies, tools, and outcomes achieved by integrating development, security, and operations processes throughout the software development lifecycle (SDLC).
## _Methodology_
_Our project adopted the following DevSecOps practices:_

- **Shift Left Security:** Security considerations were integrated from the initial planning stages, ensuring early identification and mitigation of vulnerabilities.
- **Continuous Integration and Continuous Delivery (CI/CD):** An automated pipeline was established to continuously integrate code changes, run security scans, and deploy builds to testing and production environments.
- **Infrastructure as Code (IaC)**: Infrastructure configurations were managed as code, enabling consistent and secure deployments across environments.
- **Security Automation:** Security testing tools were integrated into the CI/CD pipeline to automate vulnerability scanning.
- **Collaboration and Communication:** Regular communication and collaboration between development, security, and operations teams were fostered to ensure alignment and address security concerns promptly.

## Architecture Diagram

![Architecture diagram](./screenshots/Archi.jpeg)

## _Tools and Technologies_
_Our project utilized various tools and technologies to support the DevSecOps approach:_

- **Computing platform & services:** [AWS Cloud, S3 buckets, DynamoDB, ACM, ACL, SSM, OAC, Cloudfront, Route53 ... ]
- **Version control system (VCS):** [GitHub]
- **CI/CD pipeline tool:** [GitHub Action] 
- **Security scanning tools:** [WAF, Checkov, Snyk]
- **Static Application Security Testing (SAST):** [Snyk]
- **Dynamic Application Security Testing (DAST):** [Snyk] 
- **Infrastructure Security Scanning:** [Checkov & Snyk] 
- **IaC tools:** [Terraform] 
- **Communication platforms:** [Slack, Zoom, Microsoft Team]

## Branching Strategies

![Gitflow diagram overview](./screenshots/branching-strategy.png)
Main (Production) > Development > Features

- Main branch
![image](https://github.com/angkb/Quintet-Group3/assets/83577245/3ae4f0d0-614c-4675-a210-7c40744b7a07)

Production-ready branch for deployment. Branch protection enabled.

- <span style="color: lightblue">Development branch</span>
 ![image](https://github.com/angkb/Quintet-Group3/assets/83577245/9d3bf2da-904b-475b-ba02-b3d404c3210c)


Code-ready branch with implemented features added via different phases of the project. Branch protection enabled.

-  <span style="color: green">Features branch</span>

Accessible branch to all team members continuously updated with features and upgrades throughout the development stages for debugging for implementation into the development branch.

## _Outcomes_
_The implementation of DevSecOps resulted in several positive outcomes:_

- **Improved security posture:** Early identification and remediation of vulnerabilities throughout the SDLC significantly reduced security risks.
- **Faster time to market:** Automated testing and deployment processes accelerated software delivery timelines.
- **Enhanced collaboration:** Continuous communication and shared ownership of security fostered a collaborative and efficient development environment.
- **Increased operational efficiency:** Infrastructure automation streamlined deployments and reduced manual configuration errors.

## Challengers and Lessons Learned

_Challenger(s) encountered:_

- **Initial integration complexity:**
Integrating security tools and processes into existing workflows required initial effort and adaptation.
- **Cultural shift:**
Fostering a culture of shared security responsibility across development, security, and operations teams took time and ongoing communication. Messy start

## Conclusion 
The DevSecOps approach successfully enhanced the security, efficiency, and collaboration within the [Project Name] project. By integrating security considerations throughout the SDLC and leveraging automation tools, the project achieved faster delivery times, improved security posture, and streamlined operations. The lessons learned from this project will be valuable for future endeavors, fostering a secure and efficient software development environment.

## Next Steps
**The project team will continue to:**

- Refine and improve the DevSecOps pipeline for increased efficiency and effectiveness.
- Foster a continuous learning culture to stay updated on emerging security threats and best practices.
- Explore opportunities to expand the DevSecOps approach to other projects within the organization.



In progress..
____________________________________________________________
DevSecOps is the seamless integration of security with two other disciplines: devlopment and operations. Main purpose is to build security into the Continuous Integration and Continuos Delivery (CI/CD) pipeline. Enabling fast and secure software releases, while rapidly detecting and responding to security flaws (vulnerabilities - such as Cross-site Scriping, Broken Access Control, SQL Injection, Insecure Sesign, Poor Data Sanitization and others mentioned in OWASP).


Deploy a static website for wellness client in various region.
Implement security measures 
https://dynamics.sctp-sandbox.com/


____________________________________________________________
## Team consist of:
- Ang Kok Beng
- Joseph Ong
- Lim Wei Jie
- Muhammad Rudyn
- Sagar Ingale
____________________________________________________________
## Scenario
You are working in a unicorn startup and they are rapidly scaling their products to markets in several regions. Due to the market competition, security vulnerabilities screening has always been hindering the product release. You are tasked to turn the current DevOps Pipeline into DevSecOps. This means that you are to implement relevant security measures at each stage of the CICD Pipeline. In this project, you will be required to set up a simple CICD pipeline while focusing on the security measures introduced to it.


Quintet wellness and Healthcare.

Providing wellness and healthcare services to you at your doorstep, at comfort place.

We provide various exercise and wellness programmes for individuals and for group/corporate activities.
We also here to provide nursing services and confinement services in near future.

Our highly qualified team will help you to achieve your goals with structured, scientific and fun classes, workshops and events.

Please follow us on our Instagram and contact us to book our services now. ❤️

PS
We can add testimonial/kind words about company services and experiences from
customers

____________________________________________________________
## Getting Started (What)
To host a simple HTML file on an S3 static website, you can use a CI/CD pipeline to create an S3 bucket using Terraform. 
The newest index.html file from this GitHub repository can then be uploaded and automatically updated whenever there is a push to any branch.

____________________________________________________________
## CICD Pipeline (How)

### Visual Studio Code (VSCode) 
Using VSCode, a free and open-source source code editor provides a rich set of features for coding, debugging and version control. It is highly customisable through its extensive library of extensions, enable tailoring with several Command-Line Interface (CLI)   

- Terraform CLI
- AWS CLI
- Git CLI
- 
- 

### Git + Github (Version control system)
Using Git as a version control system that tracks changes to files while GitHub as a web-based platform that hosts Git repositories and provides collaboration features for developers.

Create a new repositories on GitHub (remote) 

Assign appropriate access to the group members as collaborators based on their role, work with Pull Request & Merging

Use Secret manager to store sensitive information


### Terraform (Provision of infrasture)
Using Terraform in CI/CD pipelines is a common practice for automating infrastructure provisioning and management. Write the Terraform script to be used in the CD pipeline
DevOps lifecycle check in local device
- Build
- Test 
- Deploy
- Operate
- Observe
- Continuous Feedback (If any)
- Discover
- Plan

Using Snyk to check for vulnerability in the code

>The rational choice to use Snyk lies in its ability to enhance the security posture of software projects by effectively detecting, preventing, and mitigating security vulnerabilities throughout the development lifecycle. It offers a combination of comprehensive coverage, ease of integration, developer->friendly approach, automation, and compliance support, making it a valuable tool for organizations looking to prioritize security in their software >development processes. We use Snyk as it integrates seamlessly into existing development workflows and tools, such as GitHub, and IDEs like VS Code. And >can incorporate security checks into our workflows without significant disruption.


### AWS (Hosting of website)
Create a static Web Application hosted in S3 
Enable and configure the following:
- S3 Policy + OAC (For access control from the web)
- IAM Role (For access control from GitHub action)
- Cloudfront WAF and Shield (Default enable)
- ACM (for seamless web surfing through SSL/TLS)

Create a bucket to store statefile.tf in S3


### GitHub Action

>GitHub Actions is a powerful tool for automating workflows directly within GitHub repository. Reasons why the team use GitHub Actions are  as follow:

**i**.It can be used to automatically build, test, and deploy code whenever changes are pushed to repository. This helps catch bugs early and ensures that codebase remains in a working state.

**ii**.Once code passes the CI tests, GitHub Actions can automate the deployment process to various environments such as staging (herein as development branch) or (herein as main branch) production. This streamlines the release process and reduces the likelihood of human error.

**iii**.GitHub Actions allows defining custom workflows using YAML syntax, giving us full control over the automation process. We can specify the sequence of steps to execute, define dependencies between jobs, and customize the environment in which our code runs.

**iv**.GitHub Actions integrates seamlessly with other services and tools, allowing incorporation into workflow which includes service AWS for cloud infrastructure



Write CI and CD pipeline script for automated deployment and updates when ever a pull request [*push to main branch] is allowed

The static webpages can be built, tests can be run, and the application can be deployed.

Using Snyk to check for vulnerability

____________________________________________________________

## Architecture Diagram

![Architecture diagram](./screenshots/Archi.jpeg)

## Dependencies

- AWS S3 bucket
- Snyk
- Terraform

## Application steps (DevOps)

### workflow (Github action)

### S3 Bucket (HTML)

## Branching Strategies

![Gitflow diagram overview](./screenshots/branching-strategy.png)
Main (Production) > Development > Features

- Main branch
  ![image](https://github.com/angkb/Quintet-Group3/assets/83577245/3ae4f0d0-614c-4675-a210-7c40744b7a07)


Production-ready branch for deployment. Branch protection enabled.

- Development branch

  ![image](https://github.com/angkb/Quintet-Group3/assets/83577245/9d3bf2da-904b-475b-ba02-b3d404c3210c)


Code-ready branch with implemented features added via different phases of the project. Branch protection enabled.

- Features branch

Accessible branch to all team members continuously updated with features and upgrades throughout the development stages for debugging for implementation into the development branch.

## Security Steps (Sec)

### Github branch merge

### Security in AWS

### Secrets in Github

### S3 Bucket (Statefile)

### Vulnerability Scan

## Lesson Learnt

## Debugging

Refer to the [HISTORY.md](/HISTORY.md) for a list of notable bugs and errors encountered.

## Area for Improvements

## Resources

## Section for Pre-requisites

>One time setup effort to create DynamoDB table (state-lock) + s3 bucket for an effective approach in distributed systems to ensure consistency and prevent concurrent modifications to shared resources.By leveraging DynamoDB for state locking, we build a highly scalable, reliable, and performant locking mechanism that ensures data consistency and prevents conflicts in distributed systems.

**i**.Create a Lock Table: Create a DynamoDB table dedicated to storing lock information. This table might have attributes like LockId, Resource, Holder, ExpirationTime.

**ii**.Acquire Lock: When a member wants to acquire a lock on a resource, it can use a conditional write operation to atomically create a new item in the lock table if the resource is not already locked. The member can include a condition that ensures the resource is not already locked by another member.

**iii**.Release Lock: When the member no longer needs the lock, it can simply delete the corresponding item from the lock table.

**iv**.Handle Expirations: To prevent deadlocks in case a member crashes or fails to release the lock, you can include an expiration time with each lock. DynamoDB's TTL (Time-To-Live) feature can automatically delete expired lock items, ensuring that resources are not locked indefinitely.

# Test

















