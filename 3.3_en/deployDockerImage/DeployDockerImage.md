# Deploy Application using Docker Image
Deploy the application using Docker Image.

**the purpose**  
Understand the followings.
- Security Context Constraints
- Service Account
- Policy

## Setting up the policy
```
Oadm policy add-scc-to-group anyuid system: serviceaccounts: <PROJECT_NAME>
```

## Deploying the application
1. Login to Administration Web  
Access `https://<URL of user environment>`.

2. Create a project  
Click the "New Project" button to start the project creation wizard.

3. Set the Project Name  
On the "New Project" screen, enter "imageapp" in the Name field and click the "Create" button.

4. Choose deployment method  
Select "Deploy Image" on the tab at the top of "Add to Project" screen.
![deployImageTab.png](../../3.3/deployDockerImage/deployImageTab.png)

5. Select a container image  
Specify the pull spec of the external Docker Registry and click the magnifying glass icon.  
**ImageName: `docker.io / jboss / wildfly`**  
If a container image is found, detailed information is displayed.
![Wildflyimage](../../3.3/deployDockerImage/wildflyimage.png)

6. Deploy the application  
Click the "Create" button at the bottom of the screen.

7. Confirm deployment  
Click on the 'Continue to overview' link on the 'Next Steps' screen.

8. Route creation  
In the specified build, there is no route to access from the client, so click "Create Route" to create the route.
![Wildfly pod](../../3.3/deployDockerImage/wildflypod.png)

| Name | value |
| --- | --- |
| Name | wildfly (default) |
| Hostname | (no input) |
| Path | (no input) |
| Service | wildfly (default) |
| Target Port | 8080 -> 8080 (TCP) (As default) |
If Hostname is not specified, the URL is generated with **`<application name>-<project name>.<Default subdomain name>`**.

9. Visit your application    
Access the application by clicking the URL displayed on the "Overview" screen.
