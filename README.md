# Домашнее задание к занятию "`Хранение в K8s`" - `Ефимов Вячеслав`


---

### Задание 1

#### [containers-data-exchange.yml](https://github.com/IthnHuitn/k8s/blob/volumes/containers-data-exchange.yml)

#### описание пода с контейнерами
![volumes1-4](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes1-4.png)
![volumes1-5](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes1-5.png)

#### вывод команды чтения файла
![volumes1-1](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes1-1.png)
![volumes1-2](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes1-2.png)

#### из контейнера busybox
![volumes1-3](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes1-3.png)

---

### Задание 2

#### [pv-pvc.yml](https://github.com/IthnHuitn/k8s/blob/volumes/pv-pvc.yml)

![volumes2-1](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes2-1.png)

#### доступ из контейнеров
![volumes2-2](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes2-2.png)

#### удаление Deployment и PVC, наличие файла
![volumes2-3](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes2-3.png)

```text
После удаления PVC, PV переходит в состояние Released. Это происходит потому, 
что установлен параметр persistentVolumeReclaimPolicy: Retain. При политике Retain,
PV не удаляется автоматически, а остается в кластере для ручного управления.
Данные на физическом томе сохраняются, но PV больше не может быть использован новым PVC,
пока администратор вручную не очистит его.
```

#### удаление PV и сохранённые данные
![volumes2-4](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes2-4.png)

```text
После удаления PV файл /mnt/data/shared.txt остается на диске ноды. Это происходит потому, что:

   1. PV - это всего лишь абстракция в Kubernetes, описывающая том хранения

   2. Удаление PV не влияет на физические данные на диске

   3. Данные хранятся непосредственно в файловой системе ноды по пути /mnt/data/

   4. Kubernetes не управляет жизненным циклом данных на локальном диске - это ответственность администратора

Если бы мы использовали политику Delete, то при удалении PVC данные были бы автоматически удалены, 
но для local PV это не применяется, так как Kubernetes не может безопасно удалить локальные данные.
```
---

### Задание 3

#### [sc.yml](https://github.com/IthnHuitn/k8s/blob/volumes/sc.yml)

![volumes3-1](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes3-1.png)

#### запись данных каждые 5 секунд
![volumes3-2](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes3-2.png)
![volumes3-3](https://github.com/IthnHuitn/k8s/blob/volumes/scr/volumes3-3.png)

---

