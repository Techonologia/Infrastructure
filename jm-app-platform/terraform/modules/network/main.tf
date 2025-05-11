resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("192.168.1.0/24", 4, count.index)
  availability_zone       = "ap-south-1${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-public-${count.index}"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
