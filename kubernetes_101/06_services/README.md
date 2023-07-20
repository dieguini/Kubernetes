# Services

Services enable communication between components

## Service - Example help

- Users connect to front end app _through service_
- Front end app connect to back end _through service_
- Front end app connect to external data source _through service_

## Service - First View Node Port

If I want to connect to a Pod it's necessary a **service**. The **service** will redirect the traffic from my laptop to the Pod inside the cluster

- My Laptop: 192.168.1.2
- Pod: 10.244.0.2
- Service: Listen to port 30008 and redirects traffic to Pod (Acting in the middle)

## Service Types

- **NodePort**: _Service_ makes accessible Pod through Port
- **ClusterIP**: _Service_ creates VIP inside cluster (Mostly used to communicate front to back)
- **LoadBalancer**: Supported Cloud Providers

## NodePort

**Hint**: Always thing from the _service perspective_ (Talk as if you were the service)

1. **TargetPort**: Port of Pod
2. **Port**: My service port
3. **NodePort**: External port (30000 - 32767)

```yaml
apiVersion: v1
kind: Service
metadata:
	name: myapp-service
spec:
	type: NodePort
	ports:
	- targetPort: 80
	  port: 80
	  nodePort: 30008
	selector:
		<labels_of_application>
```

<ins>Ifs</ins>

- If no _Target port_ provided => same as _Port_
- If no _NodePort_ provided => Automatically get (30000 - 32767)

## What happened when?

- **Multiple Pods?**: Service automatically acts as LB between Pods
- **Multiple Nodes?**: Same, it's magic

## Hands on Practice

Test files:

1. Create the [Deployment](nginx-deployment-definition.yaml)
2. Create the [Service](service-definition.yaml)
3. Check service

```shell
kubectl get services -o wide
```

4. Get nodes

```shell
kubectl get nodes -o wide
```

5. Curlit: Your IPs may varied

```
curl -I 172.19.0.5:30004
curl -I 172.19.0.4:30004
curl -I 172.19.0.2:30004
```

Have Fun!



