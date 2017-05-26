# リソース制限

## コンピュートリソースの制限


[compute-resource.yaml]
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
    pods: "4" 
    requests.cpu: "5" 
    requests.memory: 500Mi
    limits.cpu: "10" 
    limits.memory: 2Gi  
```


```
oc create -f compute-resource.yaml -n [PROJECT_NAME]
```


[pod-limit-range.yaml]
```
apiVersion: "v1"
kind: "LimitRange"
metadata:
  name: "core-resource-limits" 
spec:
  limits:
    - type: "Pod"
      max:
        cpu: "2" 
        memory: "1Gi" 
      min:
        cpu: "200m" 
        memory: "6Mi" 
    - type: "Container"
      max:
        cpu: "2" 
        memory: "1Gi" 
      min:
        cpu: "100m" 
        memory: "4Mi" 
      default:
        cpu: "300m" 
        memory: "200Mi" 
      defaultRequest:
        cpu: "200m" 
        memory: "100Mi" 
      maxLimitRequestRatio:
        cpu: "10" 
```


# Pod作成時に指定する場合
Pod
resources:
  requests:
    cpu: 1
    memory: 10Mi
  limits:
    cpu: 10
    memory: 200Mi

