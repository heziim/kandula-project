# What i've done:

## Build kandula container
* create instance with opsschool ami + install docker
* attach IAMrole (with AmazonEC2ReadOnlyAccess policy only)
* go to instance and "git clone https://github.com/heziim/kandula_assignment.git"
* add "ENV AWS_DEFAULT_REGION=us-east-1" to the Dockerfile
* docker build -t heziim/kandula:1.0 kandula_assignment/
* docker run -d -p 80:5000 heziim/kandula:1.0
* go to external ip of the instance in port 80 and view kandula data OK
---
## Deploy kandula on k8s
* deploy eks with https://github.com/ops-school/kubernetes/tree/main/eks-terraform
```
[hezi@ninja pods]$ cat pod-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  selector:
    app: kandula
  type: LoadBalancer
  ports:
    - name: http
      port: 80
      targetPort: 5000
      nodePort: 30036
      protocol: TCP
[hezi@ninja pods]$
[hezi@ninja pods]$ cat kandula.yaml
# Create a pod and expose port 5000
apiVersion: v1
kind: Pod
metadata:
  name: kandula-pod
  labels:
    app: kandula
spec:
  containers:
    - image: heziim/kandula:1.1
      name: kandula
      ports:
        - containerPort: 5000
          name: http
          protocol: TCP
[hezi@ninja pods]$
```
```
kubectl create -f pod-svc.yaml
kubectl create -f kandula.yaml
```
* attach ec2-readonly policy to IAM role that attach to the eks workers
* go to LB address and view kandula OK



---
## Deploy kandula on eks from jenkins pipeline

* create and attach role with admin access to jenkins agent
* after deploy of eks, add new cred in jenkins and put there the kubeconfig file 
```
cat kubeconfig_kandula_hezi
```
* edit the aws-auth-cm.yaml
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::636145310078:role/kandula_hezi2021010609295916000000000a
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:iam::636145310078:instance-profile/aws_cli
      username: aws_cli
      groups:
        - system:masters
        
```
* take the rolearn from "kubectl get configmap aws-auth -n kube-system -o yaml"
```
aws eks --region=us-east-1 update-kubeconfig --name kandula_hezi
kubectl apply -f aws-auth-cm.yaml
kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
```
