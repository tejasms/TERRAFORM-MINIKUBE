provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Update this path if necessary
}

resource "aws_security_group" "my_security_group" {
  name = "my-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0522ab6e1ddcc7055"  # Ubuntu 22.04 AMI in ap-south-1
  instance_type = "t2.large"
  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]


  connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y",
      " touch file1"
    ]
  }
}
