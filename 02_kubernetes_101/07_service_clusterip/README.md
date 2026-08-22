# Services - ClusterIP

Mostly used for back-end tiers

<ins>Requirement</ins>

- Front-end Pods need to access back-end Pods
- Back-end Pods need to access redis Pods

<ins>Problems</ins>

- We know that IP addresses are not static (Will change on because Pods are ephemeral), can't relay on IP for communication
- First front-end Pod will communicate to which back-end Pod?
- Who makes the decision?

<ins>Solution</ins>

- A _Cluster IP_ back-end _Service_ could be created to group all back-end Pods
- A _Cluster IP_ redis _Service_ could be created to group all redis Pods

## Syntax

**Note**: In fact this is the default 

```yaml
apiVersion: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP
  ports:
    - targetPort: 80
      port: 80
  selector:
    app: sql-backend
```

## Hands on Practice

Test files:

1. Create the [Redis Deployment](redis-deployment.yaml)
2. Create the [Service](service-definition.yaml)

**Note**: It's a ClusterIP so don't spect to much, the theory is more important in this case

