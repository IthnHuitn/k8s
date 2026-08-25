# Домашнее задание к занятию "`Установка Kubernetes`" - `Ефимов Вячеслав`


---

### Задание 1

#### Цель задания

- Установить кластер K8s.

```text
Установку выполнил на Yandex.Cloud с помощью kubeadm. Развернул инфраструктуру - 1 мастер 
и 4 ноды при помощи terraform и начал последовательную установку кластера K8S командами:
```

### подключение Master Node  
```bash
# Отключение swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Загрузка модулей ядра
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Настройка sysctl
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Установка containerd
sudo apt-get update
sudo apt-get install -y ca-certificates curl

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

# Настройка containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Установка Kubernetes 1.33
sudo apt-get install -y apt-transport-https curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable kubelet

# Инициализация кластера
sudo kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --kubernetes-version=v1.33.0 \
  --control-plane-endpoint=10.10.0.25:6443

# Настройка kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Установка сетевого плагина Flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Проверка
kubectl get nodes
kubectl get pods -n kube-system

# Сохранение join-команды
kubeadm token create --print-join-command | tee ~/join-command.txt
```
---
### Установка сетевого плагина на мастере
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
---

### подключение 4 Worker Node - выполняю команды на каждой ноде
```bash

# Установка компонентов
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

# Установка containerd
sudo apt-get update
sudo apt-get install -y ca-certificates curl

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

# Установка kubeadm
sudo apt-get install -y apt-transport-https curl

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable kubelet

# Подключение к кластеру (используйте команду с мастера)
sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```

---
 #### последовательное подключение нод
![deploy1-1](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy1-1.png)
---
#### Проверка кластера
![deploy1-2](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy1-2.png)
---
#### Проверка работоспособности
![deploy1-3](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy1-3.png)
![deploy1-4](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy1-4.png)
![deploy1-5](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy1-5.png)


---

### Задание 2*Установить HA-кластер

```bash
# Для установки HA-кластера к уже имеющейся инфраструктуре добавил две ВМ, и выполнил
# установку компонентов как для обычной ноды. На первой мастер-ноде згрузил сертификаты 
# для новых мастеров командой: 
kubeadm init phase upload-certs --upload-certs
# На каждой новой мастер-ноде выполнил join-команду используя данные с первого мастера:
sudo kubeadm join 10.10.0.25:6443 \
  --token <TOKEN> \
  --discovery-token-ca-cert-hash sha256:<HASH> \
  --control-plane \
  --certificate-key <CERTIFICATE_KEY>
```

### Настройка HAProxy и Keepalived на всех 3 мастерах

```bash
# Установка HAProxy и Keepalived
sudo apt-get update
sudo apt-get install -y haproxy keepalived

# Настройка HAProxy
sudo tee /etc/haproxy/haproxy.cfg <<EOF
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon

defaults
    log global
    mode tcp
    option tcplog
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend kubernetes-frontend
    bind *:8443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server master-1 10.10.0.25:6443 check fall 3 rise 2
    server master-2 10.10.0.35:6443 check fall 3 rise 2
    server master-3 10.10.0.17:6443 check fall 3 rise 2
EOF

# Настройка Keepalived
sudo tee /etc/keepalived/keepalived.conf <<EOF
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass k8scluster
    }
    virtual_ipaddress {
        10.10.0.100/24
    }
}
EOF

# Запуск сервисов
sudo systemctl enable haproxy keepalived
sudo systemctl restart haproxy keepalived

# Проверка
sudo systemctl status haproxy
sudo systemctl status keepalived
```

#### Обновляю конфигурацию kubectl на всех мастерах
```bash
# На первом мастере обновляю конфиг
sudo kubeadm init phase upload-config kubeadm

# Копирую обновленный конфиг на все мастера
sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
```
#### Проверка HA кластера

##### Разные команды на трёх мастерах с общим результатом

![deploy-HA1-1](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy-HA1-1.png)
![deploy-HA1-2](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy-HA1-2.png)
![deploy-HA1-3](https://github.com/IthnHuitn/k8s/blob/k8s-deploy/scr/deploy-HA1-3.png)

---