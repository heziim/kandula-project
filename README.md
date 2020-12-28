# kandula-project
The mighty warrior elephant who saved us!

:elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant::elephant:

What i've done:
* create instance with opsschool ami + install docker
* attach IAMrole (with AmazonEC2ReadOnlyAccess policy only)
* go to instance and "git clone https://github.com/heziim/kandula_assignment.git"
* add "ENV AWS_DEFAULT_REGION=us-east-1" to the  Dockerfile
* docker build -t heziim/kandula:1.0 kandula_assignment/
* docker run -d -p 80:5000 heziim/kandula:1.0
* go to external ip of the instance in port 80 and view kandula data OK
