# terraform-flask-sanity
<img width="857" alt="Architecture of sanity setup" src="https://github.com/user-attachments/assets/d5e13d72-95ac-41e1-8c9d-3b6b209b4b1c">
<img width="738" alt="Sanity Setup" src="https://github.com/user-attachments/assets/6a0e643d-b38c-41f8-85d2-cc8f37795efe">

1. This project involves setting up a Flask application on an EC2 instance using Terraform.
2. First, a VPC with a specified CIDR block is created, followed by a public subnet within the VPC.
3. An Internet Gateway (IGW) is attached to the VPC, and the route table is updated for internet access.
4. A security group is configured to allow inbound traffic on port 80 and 22 and outbound traffic.
5. An EC2 instance is defined within the public subnet, with the necessary instance type, AMI, key pair, and security group.
6. Terraform provisioners are used to install Python and Flask on the EC2 instance and clone the Flask application from a repository.
7. A startup script ensures the Flask application starts automatically.
8. The public IP of the EC2 instance is outputted for easy access.
9. Finally, the setup ensures the Flask application can be updated by the developer by pulling the latest changes from a version control system and restarting the server.
