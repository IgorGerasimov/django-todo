# GTD: Conteinerised site for django-todo

[Django-todo](https://github.com/shacker/django-todo) is a reusable app that can be plugged into any running Django
project. If you don't have a handy Django project to plug it into, or just want a quick starter site to try django-todo
in, this project is the reference / example host site used by the author (though you might find it handy as a generic
Django starter site for other purposes as well).

## Installation/running locallly 
### requiments: pipenv, python3, pip


```
git clone https://github.com/IgorGerasimov/django-todo
cd django-todo
pipenv install # Installs all dependencies
pipenv shell  # Activates the environment
```

Modify to match your local db credentials. In `project/local.py`:

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

Then:

`./manage.py migrate`




## Installation/running locallly with docker-compose
### requiments: pipenv, python3, pip, docker, docker-compose

```
git clone https://github.com/IgorGerasimov/django-todo
cd django-todo
```

for building of docker image manually `docker build --no-cache -t <registry>/django-todo .`

Modify to match your local db credentials. In `project/local.py`:

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'postgres',
        'PASSWORD': 'postgres',
        'HOST': 'postgres-postgresql',
        'PORT': '',
    },
}
```

Then:

`docker-compose run web python /code/manage.py migrate --noinput` - to migrate data to postgres

To run the app 

`docker-compose up -d --build`

App should be available via `http://127.0.0.1:8000/`


## Kubernetes with eksctl setup 

`eksctl create -f eksctl/django-todo-v1.yaml`

## Installation/running locallly with kubernetes/minikube
### requiments: pipenv, python3, pip, docker, docker-compose, minikube 'brew install minikube', virtualbox, helm2, kubectl
links:
`https://www.virtualbox.org/wiki/Downloads` - virtualbox
`https://kubernetes.io/docs/tasks/tools/install-minikube/` - minikube
`https://helm.sh/docs/intro/install/` - helm2

- then run `minikube start --vm-driver=virtualbox` to starg minikube on top of virtualbox.
- to verify correct installation and running of minikube execute `kubectl get pods --all-namespaces` - if you see list of running pods and they are in `Running` state - you made it.
- to install `helm` execute `helm init`, if you see blank ( without errors) output of command `helm ls -a`, then you good ( RBAC is not enables in minikube ).
- execute `minikube addons enable ingress` to enable `ingress-controller` for minikube
- we also need 2 components: `postgresql` and `nginx`
   postgresql install `helm install postgres stable/postgresql -f helm values-postgres.yaml`
   execute `minikube addons enable ingress` to enable `ingress-controller` for minikube
- after all those steps you have working infra for running of `django-todo` on kubernetes
   django-todo install `helm install --wait --name django-todo helm/`


Now we need to open it via browser: 
- connect to VM `minikube ssh`
- get ip of your VM `ifconfig` - you need ip if external interface

  ```
  eth1      Link encap:Ethernet  HWaddr 08:00:27:32:C5:37
          inet addr:192.168.99.100  Bcast:192.168.99.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:228043 errors:0 dropped:0 overruns:0 frame:0
          TX packets:121439 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:36052695 (34.3 MiB)  TX bytes:134394782 (128.1 MiB)
  ```
- add such record ``192.168.99.100 hello-world.info` to your `/etc/hosts` file.
- open `hello-world.info` in browser


![working screnshot](/pics/working_screen.png)






TO-DO

1. settings.py for different env's ( not sure how is it working in python ) - not done
2. helm `command` instead of Dockerfile `CMD` - done
3. `migration` in process of start of `django-todo` app - done



![scheme of current setup](/pics/scheme.png)
