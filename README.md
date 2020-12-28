# kandula-project
The mighty warrior elephant who saved us!

:elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant:

What i've done:
* crete vm with opsschool ami
* attchh IAMrole (with ec2 readonly policy)
* add "ENV AWS_DEFAULT_REGION=us-east-1" to the  Dockerfile
* go to instance and "git clone https://github.com/heziim/kandula_assignment.git"
* docker build -t heziim/kandula:1.0 kandula_assignment/
* docker run -d -p 80:5000 heziim/kandula:1.0
