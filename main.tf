provider "aws" {
  region     = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_CIDR
  tags = {
    Name = "mytaverse"
  }
}

resource "aws_subnet" "Public-subnet-1" {
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet-1

  tags = {
    Name = "Public-subnet-2a"
  }
}

resource "aws_subnet" "Public-subnet-2" {
  availability_zone = "us-east-2b"
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet-2

  tags = {
    Name = "Public-subnet-2b"
  }
}

resource "aws_subnet" "Private-subnet-1" {
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet-3

  tags = {
    Name = "Private-subnet-2a"
  }
}

resource "aws_subnet" "Private-subnet-2" {
  availability_zone = "us-east-2b"
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet-4

  tags = {
    Name = "Private-subnet-2b"
  }
}

resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
    } 


  tags = {
    Name = "Public-RT"
  }

}

resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.main.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_nat_gateway.nat_gateway.id}"
    }


  tags = {
    Name = "Private-RT"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

    tags = {
    "Name" = "InternetGateway"
  }
}

resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



resource "aws_route_table_association" "subnet-1-RT" {
  subnet_id      = aws_subnet.Public-subnet-1.id
  route_table_id = aws_route_table.public_subnet_rt.id

}

resource "aws_route_table_association" "subnet-2-RT" {
  subnet_id      = aws_subnet.Public-subnet-2.id
  route_table_id = aws_route_table.public_subnet_rt.id

}

resource "aws_route_table_association" "subnet-3-RT" {
  subnet_id      = aws_subnet.Private-subnet-1.id
  route_table_id = aws_route_table.private_subnet_rt.id

}

resource "aws_route_table_association" "subnet-4-RT" {
  subnet_id      = aws_subnet.Private-subnet-1.id
  route_table_id = aws_route_table.private_subnet_rt.id

}

resource "aws_network_acl" "acl" { 
  vpc_id = aws_vpc.main.id 
  subnet_ids = [ aws_subnet.Public-subnet-1.id,aws_subnet.Public-subnet-2.id,aws_subnet.Private-subnet-1.id,aws_subnet.Private-subnet-2.id] 
  # allow ingress port all port 
  ingress { 
    protocol = "-1" 
    rule_no = 100 
    action = "allow" 
    cidr_block = "0.0.0.0/0" 
    from_port = 0 
    to_port = 0 
  } 
  # allow egress port all port 
  egress { 
    protocol = "-1" 
    rule_no = 100 
    action = "allow" 
    cidr_block = "0.0.0.0/0" 
    from_port = 0 
    to_port = 0 
  } 
}

resource "aws_eip" "nat_gateway" {
  vpc = true
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.Public-subnet-1.id
  tags = {
    "Name" = "NatGateway"
  }
}