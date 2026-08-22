# Voting App - Deployments

Same as [Voting App - Pods](../08_voting_app_pods) but with deployments

## Hands on Practice

Ok after some testing there is a correct way in deploying because of this:

- Worker will call redis and db
- **!! If there are no service the _worker_ Pod will fail "CrashLoopBackOff" !!**

Test files, suggest order:

1. Create the **DB**
    - [Postgres Deployment](00_postgres-deploy.yaml)
    - [Postgres Service](01_postgres-service.yaml)
2. Create **Redis**
    - [Redis Deployment](02_redis-deploy.yaml)
    - [Redis Service](03_redis-service.yaml)
3. Create **Worker**
    - [Worker Deployment](08_worker-deploy.yaml)
4. Create **Voting** and **Resulting App**
    - [Voting App](04_voting-app-deploy.yaml)
    - [Voting Service](05_voting-app-service.yaml)
    - [Resulting App](06_result-app-deploy.yaml)
    - [Resulting Service](07_result-app-service.yaml)

Usefull command to create all

```shell
kubectl create -f 09_voting_app_deployments/
```

### Have fun

```shell
kubectl scale deployment voting-app-deployment --replicas=3
```

```shell
kubectl scale deployment result-app-deployment --replicas=3
```

```shell
kubectl get deployments.apps 
```
