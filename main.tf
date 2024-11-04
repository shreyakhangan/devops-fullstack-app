provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "k8s_instance" {
  ami           = "ami-0e001c9271cf7f3b9"
  instance_type = "t2.micro"
  availability_zone = "us-west-2b" 
  tags = {
    Name = "K8s-Instance"
  }
}

resource "aws_ebs_volume" "k8s_volume" {
  availability_zone = aws_instance.k8s_us-west-2b"
  size              = 10
}

resource "aws_volume_attachment" "k8s_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = "vol-05fcf160357f56e06"
  instance_id = "i-013bb2281f6b29997"
}

output "instance_ip" {
  value = aws_instance.k8s_instance.public_ip
}
