# Create VPC 
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.region

  tags = {
    Name = "public"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# # Generate SSH Key Pair
# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# # Create AWS Key Pair
# resource "aws_key_pair" "ssh" {
#   key_name   = "ec2-key"
#   public_key = tls_private_key.ssh.public_key_openssh
# }

# # Save private key locally
# resource "local_file" "private_key" {
#   content         = tls_private_key.ssh.private_key_pem
#   filename        = "ec2-key.pem"
#   file_permission = "0400"
# }

# Generate SSH Key Pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "ssh" {
  key_name   = "ec2-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "ec2-key.pem"
  file_permission = "0400"
}

# # Use null_resource to run local commands after file creation
# resource "null_resource" "fix_permissions" {
#   depends_on = [local_file.private_key]

#   provisioner "local-exec" {
#     command = "sudo chown $USER:$USER ec2-key.pem && sudo chmod 400 ec2-key.pem"
#   }
# }

# Create Security Group
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_ssh_http_https"
  }
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ima
  instance_type = var.ec2_type

  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http_https.id]
  associate_public_ip_address = true
  key_name                   = aws_key_pair.ssh.key_name

  root_block_device {
    volume_size = 30  # 30 GB root volume
    volume_type = "gp3"  # General Purpose SSD
    # encrypted   = true  # Optional: encrypt the volume
  }

  # tags = {
  #   Name = "web-server"
  # }
}

# Output values
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "ssh_private_key_path" {
  value = local_file.private_key.filename
}