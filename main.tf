# Define the AWS provider configuration.
provider "aws" {
  region = "ap-south-1" 
}

# passing a variable
variable "cidr" {
  default = "10.0.0.0/16"
}

# creating my own key pair
resource "aws_key_pair" "example" {
  key_name   = "newKey1"  # Replace with your desired key name
  public_key = file("~/.ssh/id_ed25519.pub")  # Replace with the path to your public key file
}


# creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

# creating subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# creating route table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"      # all 0s means its a public route table, all traffic comes 
    gateway_id = aws_internet_gateway.igw.id
  }
}

# attaching route table with subnet, so that it becomes public subnet
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Creating a security group for the instances
resource "aws_security_group" "sg" {
  name   = "sg_web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# creating a ec2 instance
resource "aws_instance" "server" {
  ami                    = "ami-0ad21ae1d0696ad58" # replace ami id based on requirement
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_ed25519")  # Replace with the path to your private key
    host        = self.public_ip
  }


  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

# here we are running these things inside ec2 instance without login into the machine
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo apt install python3-flask",
      "sudo python3 app.py &",
    ]
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}

