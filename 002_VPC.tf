
resource "aws_vpc" "vpc-prj2023" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = merge(var.default_tags, {
    Name = "vpc-prj2023"
  })
}

# Subnet Zona A
resource "aws_subnet" "pub-subnet-prj2023-a1" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "pubSubnet_A1_PRJ2023"
  })
}

resource "aws_subnet" "pub-subnet-prj2023-a2" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "pubSubnet_A2_PRJ2023"
  })
}

resource "aws_subnet" "prv-subnet-prj2023-a1" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "prvSubnet_A1_PRJ2023"
  })
}

resource "aws_subnet" "prv-subnet-prj2023-a2" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "prvSubnet_A2_PRJ2023"
  })
}

# Subnet Zona B
resource "aws_subnet" "pub-subnet-prj2023-b1" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.5.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "pubSubnet_B1_PRJ2023"
  })
}

resource "aws_subnet" "pub-subnet-prj2023-b2" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.6.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "pubSubnet_B2_PRJ2023"
  })
}

resource "aws_subnet" "prv-subnet-prj2023-b1" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.7.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "prvSubnet_B1_PRJ2023"
  })
}

resource "aws_subnet" "prv-subnet-prj2023-b2" {
  vpc_id                  = aws_vpc.vpc-prj2023.id
  cidr_block              = "172.16.8.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = merge(var.default_tags, {
    Name = "prvSubnet_B2_PRJ2023"
  })
}


# Internet && Nat


resource "aws_internet_gateway" "igw-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id

  tags = merge(var.default_tags, {
    Name = "IGW_PRJ2023"
  })
}

# Router Table Externa[PUB]


resource "aws_route_table" "router-ext-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id

  #Criar publico
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-prj2023.id
  }

  tags = merge(var.default_tags, {
    Name = "router_ext_PRJ2023"
  })
}

resource "aws_main_route_table_association" "assoc-ext-main-prj2023" {
  vpc_id         = aws_vpc.vpc-prj2023.id
  route_table_id = aws_route_table.router-ext-prj2023.id
}

resource "aws_route_table_association" "assoc_externa_prj2023_a1" {
  subnet_id      = aws_subnet.pub-subnet-prj2023-a1.id
  route_table_id = aws_route_table.router-ext-prj2023.id
}

resource "aws_route_table_association" "assoc_externa_prj2023_a2" {
  subnet_id      = aws_subnet.pub-subnet-prj2023-a2.id
  route_table_id = aws_route_table.router-ext-prj2023.id
}

resource "aws_route_table_association" "assoc_externa_prj2023_b1" {
  subnet_id      = aws_subnet.pub-subnet-prj2023-b1.id
  route_table_id = aws_route_table.router-ext-prj2023.id
}

resource "aws_route_table_association" "assoc_externa_prj2023_b2" {
  subnet_id      = aws_subnet.pub-subnet-prj2023-b2.id
  route_table_id = aws_route_table.router-ext-prj2023.id
}

# Router Table Interna[PRV]

resource "aws_route_table" "router-int-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id

  #Criar publico
  route {
    cidr_block = "172.16.0.0/16"
    gateway_id ="local"
  }

  tags = merge(var.default_tags, {
    Name = "router_int_PRJ2023"
  })
}

resource "aws_route_table_association" "assoc_interna_prj2023_a1" {
  subnet_id      = aws_subnet.prv-subnet-prj2023-a1.id
  route_table_id = aws_route_table.router-int-prj2023.id
}

resource "aws_route_table_association" "assoc_interna_prj2023_a2" {
  subnet_id      = aws_subnet.prv-subnet-prj2023-a2.id
  route_table_id = aws_route_table.router-int-prj2023.id
}

resource "aws_route_table_association" "assoc_interna_prj2023_b1" {
  subnet_id      = aws_subnet.prv-subnet-prj2023-b1.id
  route_table_id = aws_route_table.router-int-prj2023.id
}

resource "aws_route_table_association" "assoc_interna_prj2023_b2" {
  subnet_id      = aws_subnet.prv-subnet-prj2023-b2.id
  route_table_id = aws_route_table.router-int-prj2023.id
}
