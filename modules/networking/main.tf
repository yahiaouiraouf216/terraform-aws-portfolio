resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_a" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = "ca-central-1a"
  tags = {
    Name = "public-subnet_A"
  }
}

resource "aws_subnet" "public_b" {
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = "ca-central-1b"
  tags = {
    Name = "public-subnet_b"
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

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private_a" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = "ca-central-1a"
  tags = {
    Name = "private-subnet_A"
  }
}

resource "aws_subnet" "private_b" {
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.this.id
  availability_zone = "ca-central-1b"
  tags = {
    Name = "private-subnet_B"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "terraform-aws-portfolio-private-route-table_A"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "terraform-aws-portfolio-private-route-table_B"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_eip" "nat_a" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "terraform-aws-portfolio-nat-eip-a"
  }
}
resource "aws_eip" "nat_b" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "terraform-aws-portfolio-nat-eip-b"
  }
}
resource "aws_nat_gateway" "nat_a" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_a[0].id
  subnet_id     = aws_subnet.public_a.id
  tags = {
    Name = "terraform-aws-portfolio-nat-gateway-a"
  }
  depends_on = [aws_internet_gateway.this]
}
resource "aws_nat_gateway" "nat_b" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_b[0].id
  subnet_id     = aws_subnet.public_b.id
  tags = {
    Name = "terraform-aws-portfolio-nat-gateway-b"
  }
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_a_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a[0].id
}
resource "aws_route" "private_b_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b[0].id
}
