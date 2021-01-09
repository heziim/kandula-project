# kandula-project

:elephant: The mighty warrior elephant who saved us! :elephant:

<img src="https://media.giphy.com/media/c5iMjFfrUFpza/giphy.gif" />

Kandula is a highly available web application on AWS.<br>
This project will demonstrate a deploy of kandula app in small prod-like environment.<br>
Follow these instructions in order to build the infrastructure for kandula and run it!<br><br>

## Prerequisites

* Any Linux machine with [git](https://git-scm.com/downloads) & [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* Setup [aws credentials](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html)

## HowTO
1. Clone the repo 
    ```
    git clone https://github.com/heziim/kandula-project.git
    cd kandula-project
    ```
2. Spin up the infrastructure
    ```
     terraform init
     terraform apply
     ```
     
3. setup eks
    ```
    aws eks --region=us-east-1 update-kubeconfig --name kandula_hezi
    kubectl edit configmap aws-auth -n kube-system
    ```
    * add this group to "mapRoles:" section (XXXX is your user arn):
    ```
    - "groups":
      - system:masters
      "rolearn": arn:aws:iam::XXXXX:role/admin-access
      "username": admin-access
    ```
    
4. setup jenkins
   * install plugins:
   * connect the agents:
   * create kubernetes credentials (copy kubeconfig content. locate in  your home dir under .kube/config"
   * cretae github credentials & connect github to jenkins via githubAPP
   * buid the pipeline ( new item -> pick "MultiBranch pipeline" & give the pipeline a name -> add "GitHub" source in Branch Sources -> pick the right credentials)
   * develop [kandula](https://github.com/heziim/kandula_assignment) in feature branch ->  open pull request -> Kandula will be up on k8s lb 


