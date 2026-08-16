data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
     }
owners = ["137112412989"]

}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2.name
  lifecycle {
  ignore_changes = [ami]
}
  tags = {
    Name = "terraform-aws-portfolio-web-instance"
  
  }
}

