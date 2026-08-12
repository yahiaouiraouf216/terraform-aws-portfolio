resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
 cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.this.id
  availability_zone = "ca-central-1a"
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "terraform-aws-portfolio-igw"
     }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "terraform-aws-portfolio-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.this.id
  availability_zone = "ca-central-1a"
  tags = {
    Name = "private-subnet"
  }
}