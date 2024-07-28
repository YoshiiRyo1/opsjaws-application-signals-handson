# Chapter 2





## dice のビルド

```bash
$ eval $(minikube docker-env)

$ cd step2/dice
$ docker build -t dice .
```

```bash
$ helm repo add aws-observability https://aws-observability.github.io/helm-charts
$ helm install amazon-cloudwatch-operator aws-observability/amazon-cloudwatch-observability \
  --namespace default \
  --set region=ap-northeast-1 \
  --set clusterName=dice
```

```bash
$ kubectl patch Deployment dice-server -p '{"spec": {"template": {"metadata": {"annotations": {"instrumentation.opentelemetry.io/inject-java": "true"}}}}}'
deployment.apps/dice-server patched
```


```bash
$ kubectl rollout restart
```


```bash
$ k apply -f dice.yaml 
```


```bash
$ curl http://localhost:8080/rolldice?rolls=12
```

```bash


