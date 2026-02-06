aws_region = "us-east-1"
project_name = "strapi-app"

vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"

instance_type = "t3.micro"
ami_id = "ami-0c02fb55956c7d316"
key_name = "strapi-key"

strapi_port = 1337
environment = "dev"