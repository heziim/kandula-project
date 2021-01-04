resource "aws_iam_role" "consul-join2" {
  name               = "consul-join2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "consul-join2" {
  name = "consul-join2"
  role = aws_iam_role.consul-join2.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul-join2" {
  name  = "consul-join2"
  role = aws_iam_role.consul-join2.name
}

