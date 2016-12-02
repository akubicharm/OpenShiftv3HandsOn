# Deploy the War file
Deploy the prebuilt WAR file to JBoss EAP.

## Build the application
1. Login with CLI  
```
oc login `https://<URL of environment>`.
```

2. Create a project  
```
oc new-project wardeploy
```

3. Deploy JBoss EAP  
```
oc new-app jboss-eap 64-openshift: latest ~. - name app
```
In this command, we specify the source code of the current directory and deploy JBoss EAP under the name app.
Available ImageStream is confirmed with `oc get is -n openshift`

## Deploy the WAR file
1. Deploy the WAR file  
```
oc start - build app --from - file = jboss - kitchensink.war
```

## Create Route
1. Check service  
```
oc get svc
```

2. Create Route  
```
oc expose svc app
```

3. Confirm Route   
```
oc get Route
oc get route
NAME HOST / PORT PATH SERVICES PORT TERMINATION
App app-wardeploy.cloudapps-e49d.oslab.opentlc.com app 8080-tcp
```

## Confirmation of application
1. Visit your applicataion
`http://<Application ROUTE>/jboss-kitchensink`
