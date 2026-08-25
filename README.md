# Домашнее задание к занятию "`Как работает сеть в K8s`" - `Ефимов Вячеслав`


---

### Задание 1: Создать сетевую политику или несколько политик для обеспечения доступа

#### [backend-deployment.yaml](https://github.com/IthnHuitn/k8s/blob/net_policy/backend-deployment.yaml)   [cache-deployment.yaml](https://github.com/IthnHuitn/k8s/blob/net_policy/cache-deployment.yaml)   [frontend-deployment.yaml](https://github.com/IthnHuitn/k8s/blob/net_policy/frontend-deployment.yaml)    [network-policies.yaml](https://github.com/IthnHuitn/k8s/blob/net_policy/network-policies.yaml)

Создание namespace "App" в K8S невозможно:
```bash
evilmc@evilmc:~/netology/K8S/net_interaction$ kubectl create namespace App
The Namespace "App" is invalid: metadata.name: Invalid value: "App": a lowercase RFC 1123 label must consist of lower case alphanumeric characters or '-', and must start and end with an alphanumeric character (e.g. 'my-name',  or '123-abc', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?')
```
Создал "app".

```bash
# проверка созданных ресурсов и политик
kubectl get pods -n app
kubectl get svc -n app
kubectl get networkpolicies -n app
```
![networking1-1](https://github.com/IthnHuitn/k8s/blob/net_policy/scr/net_policy1-1.png)

### Проверка работоспособности политик
![networking1-2](https://github.com/IthnHuitn/k8s/blob/net_policy/scr/net_policy1-2.png)
![networking2-1](https://github.com/IthnHuitn/k8s/blob/net_policy/scr/net_policy1-3.png)
![networking2-2](https://github.com/IthnHuitn/k8s/blob/net_policy/scr/net_policy1-4.png)
