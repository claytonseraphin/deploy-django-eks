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

## Terraform Deployment for EKS

### Pushing updates to aws via Terraform
`aws-vault exec <profile-name> -- terraform apply`

### Authenticate to EKS from your local terminal with kubectl to have access to the Kubernetes dashboard
`aws eks --profile your_aws_profile_name --region us-east-1 update-kubeconfig --name django-k8s-cluster`

### To see the nodes running in your EKS cluster from your terminal after authenticating:
`kubectl get nodes`

### Apply recommended dashboard configuration
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml`

### Apply shared service account with kubectl
`kubectl apply -f ../deploy/dashboard-sa.yaml`

### Create a cluster role biding which gives access to our sevice account to authenticate to the dashboard
`kubectl create clusterrolebinding serviceaccounts-cluster-admin --clusterrole=cluster-admin --group=system:serviceaccounts`

### Create a auth token for the admin-user (required to authenticate with the Kubernetes Dashboard:)
`kubectl create token admin-user --duration 4h -n kubernetes-dashboard`

### Create a proxy that allows you to connect from your terminal to your EKS cluster
`kubectl proxy`
NOTE: The dashboard is accessible via this URL once the proxy is running:
`http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/`

### Apply kubernetes config (requires a kustomization.yaml file in the root of the target directory):
`kubectl apply -k ./path/to/config`

### Execute a command on a running pod (for example, to get shell or create a superuser account with Django)
`kubectl exec -it <POD NAME> sh`

## HELM
### The efs csi driver on the helm repo is deprecated. The most recent way to instakll the efs csi driver to eks is by adding it in the addons section of the eks module

## Login to ECR private:
`aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com`

## Build app image to push to ecr
`docker build -t ecr-app-url:latest --compress .`
`docker push ecr-app-url:latest`

## Build proxy image to push to ecr
`docker build -t ecr-proxy-url:latest --compress .`
``docker push ecr-proxy-url:latest``