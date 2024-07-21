### data source for getting AMI

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}


### ec2 instance

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true
  subnet_id = var.pub_sub_id
  key_name = var.key_name

  ### connecting to ec2 instance
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
    host = self.public_ip
  }
  
  ## file provisioner to copy a file from local to ec2 instance
  provisioner "file" {
    source = "../app.py"
    destination = "/home/ubuntu/app.py"
  }

  ## exec provisioner to run the required commands inside the ec2 instance
  provisioner "remote-exec" {
    inline = [ 
      "echo 'Hello from remote exec of terraform project' ",
      "sudo apt update -y",
      "sudo apt install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip install -y flask",
      "sudo python3 app.py &",
     ]
  }

  tags = {
    Name = "myEc2Instance"
  }
}