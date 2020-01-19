variable "east-ami" {
    default = "ami-0d542ef84ec55d71c"
}



variable "west-ami" {
    default = "ami-04590e7389a6e577c"
}

provider "aws" {
    version = "> 0.12"
    region = "us-west-2"
    alias = "uswest2"
}

provider "aws" {
    region = "us-east-2"
    version = "> 0.12"
    alias = "useast2"
}

resource "aws_vpc" "vpc-east" {
    provider = aws.useast2
    cidr_block = "192.168.0.0/16"
    tags    = {
        Name    = "VPC Alpha"
    }
}

resource "aws_vpc" "vpc-west" {
    provider = aws.uswest2
    cidr_block = "10.0.0.0/16"
    tags    = {
        Name    = "VPC Zeta"
    }
}

# ### ### ### ### # # ###
##  SUBNETS 
# ### ### ### ### # # ###

resource "aws_subnet" "public-east-1" {
    provider = aws.useast2
    vpc_id = aws_vpc.vpc-east.id
    cidr_block = "192.168.1.0/24"
    map_public_ip_on_launch = true 
    tags = {
        Name    = "PublicSN1"
    }

}

resource "aws_subnet" "public-west-1" {
    provider = aws.uswest2
    vpc_id = aws_vpc.vpc-west.id
    map_public_ip_on_launch = true
    cidr_block = "10.0.1.0/24"
    tags = {
        Name    = "PublicSN1"
    }
}

# ### ### ### ### # # ###
##  instances 
# ### ### ### ### # # ###

resource "aws_instance" "ec2-east" {
    provider = aws.useast2
    ami     = var.east-ami 
    key_name = "tim-ec2"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-east-1.id

    tags = {
        Name = "Instance1"
    }
}

resource "aws_instance" "ec2-west" {
    provider = aws.uswest2
    ami     = var.west-ami
    key_name = "tim-ec2"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-west-1.id

    tags = {
        Name = "Instance1"
    }
}
