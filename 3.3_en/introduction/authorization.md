# Role and policy Management
![Role Bindings](../../3.3/introduction/RoleBindings.png)

* Rule
  + Define what you can do
* Role
  + Collection of rules
* Bindings
  + Role tying
* Policy
  A mechanism that allows users to do what they can do in the Project.
    + Cluster policy
    Assign Cluster roles in the policy for all projects
    + Local policy
    Assign Local roles in policies targeting specific projects

** Default role list **

| Default Role | Details |
|---|---|
| Admin | Project administration authority. Access to all resources without project |
| Basic - user | Project and user information can be referenced |
| Edit | Authority to edit resources in project. However, reference and editing of role and bindings are not allowed |
| Self - provisioner | Create project authority. If you do not want the user to create a project, remove this privilege from the general user |
| View | Reference authority. Objects in the project can be referenced. However, role and bindings can not be referenced |
| Cluster-admin | superuser of OpenShift itself |
| Cluster-status | OpenShift's cluster status reference authority |



## Service Account
Object to control access to OpenShift API. The following service accounts are created by default in each project.
It is possible to grant authority by policy as usual user.
Service Account consists of project name and user name.

`System:serviceaccount:<project name>:<name>`


| Service Account | Details |
|---|---|
| Builder | A service account for building Pod. Systme: push the generated Docker Image to the Docker registry with the authority of image-builder and inside OpenShift |
| Deployer | Service account for deploying Pod. With the authority of system: deployer, it is possible to reference and edit Replication Controller and Pod. |
| Default | All serviceable accounts other than builder and deployer service account |

## Security Context Constraints (SCCs)
A mechanism for managing the authority of Pod.
It is possible to manage which user the Container process is executed, whether persistent storage is available, etc.

Cluster administrator, nodes, build controller can access priviledged SCC. Authenticated (logged in) general users can access the restricted SCC.

* Priviledged SCC (SCC for executing privilege container)
 + Pod with privilege can be executed
 + You can use the resources of the host running the container
 + Host server resources such as host volume mount available
   - MCS = Multi-Category Security
     - In OpenShift, container processes in the same project are given the same MCS label, and it is possible to share resources.
   - PIC = Interprocess communication
* Restricted SCC (SCC to execute restricted container)
 + Execution load as privileged container
 + Pod is executed within the range of the specified UID


## Confirm and apply SCC
### How to check the registered SCC
```
oc get scc
```

### Apply SCC to users and groups
In order to allow the authority to specific users and groups creating privileged pod, execute the following command.
```
oadm policy add-scc-to-user <scc-name> <user-name>
oadm policy add-scc-to-group <scc-name> <group-name>
```

** Example) When giving special-user authority to create privileged Pod **
```
oadm policy add-scc-to-user priviledged special-user
```

### Apply SCC to Service Account
```
oadm policy add-scc-to-user priviledged system:serviceaccount:<project name>:<service account name>
```

** Example) When applying scc to mysvc of myproject project **
```
oadm policy add-scc-to-user priviledged system:serviceaccount:myproject:mysvc
```

### Enable Docker Image downloaded from an external repository

In OpenShift, the process in the container is executed with the general user (UID = 1001).

To authorize all authenticated (logged into OpenShift) users

```
oadm policy add-scc-to-group anyuid:authenticated
```

When granting to a specific project
```
oadm policy add-scc-to-user anyuid system:serviceaccont:myproject
```
