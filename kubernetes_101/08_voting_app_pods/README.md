# Voting App - Pods

## Goals

1. **Deploy Containers**, in cluster
2. **Enable Connectivity**, between containers
3. **External Access** for users

## Steps

### Understand Flow

- External users will access _voting-app_ and _result-app_
- _voting-app_ will access _redis_
- _result-app_ will access _postgres_
- _worker_ is only a services, not accessible 

### Planning

1. Deploy as PODs
2. Create Services (==ClusterIP==)
	1. **redis**, so others access redis
	2. **db**, so others access postgres db
3. Create Services (==NodePort==)
	1. **voting-app**, so users access
	2. **result-app**, so users access

### Images

Images that are going to be used `pod`: `image`

- voting-app: kodekloud/examplevotingapp_vote:v1
- result-app: kodekloud/examplevotingapp_result:v1
- redis: redis
- postgres: postgresql
- worker: kodekloud/examplevotingapp_worker:v1

## Hands on Practice

Ok after some testing there is a correct way in deploying because of this:

- Worker will call redis and db
- **!! If there are no service the _worker_ Pod will fail "CrashLoopBackOff" !!**

Test files, suggest order:

1. Create the **DB**
    - [Postgres Pod](00_postgres-pod.yaml)
    - [Postgres Service](01_postgres-service.yaml)
2. Create **Redis**
    - [Redis Pod](02_redis-pod.yaml)
    - [Redis Service](03_redis-service.yaml)
3. Create **Worker**
    - [Worker Pod](08_worker-pod.yaml)
4. Create **Voting** and **Resulting App**
    - [Voting App](04_voting-app-pod.yaml)
    - [Voting Service](05_voting-app-service.yaml)
    - [Resulting App](06_result-app-pod.yaml)
    - [Resulting Service](07_result-app-service.yaml)

Usefull command to create all

```shell
kubectl create -f 08_voting_app/
```
