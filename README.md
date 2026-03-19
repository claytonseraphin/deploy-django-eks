# deploy-django-minikube
Deploy Django app with Minikube

### Apply Kubernetes changes
`kubectl apply -k deploy/`

### View the volume claim via command line
`kubectl get pvc`

### View the running services
`kubectl get services`

### Build the django app container
`docker buildx build -t django-app:latest .`

### Push the django-app image to minikube based on the `latest` tag
`minikube image load django-app:latest`

### Build the Nginx Proxy
`docker buildx build -t django-proxy:latest proxy/`

### Push the django-proxy image to minikube based on the `latest` tag
`minikube image load django-proxy:latest`

### Run the `django` app/service with minikube
`minikube service django`


### Create django super user using kubectl
`kubectl get pods` this should show the name of the pods running

`kubectl exec -it the_django_pod_name_or_id -c app -- python manage.py createsuperuser`
