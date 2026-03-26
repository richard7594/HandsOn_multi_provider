# This file contain only the networking resources

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "HandsOn_vpc"
  }
}

# two private subnet in separate AZ
resource "aws_subnet" "private" {
  for_each          = var.az
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pri_sub_cidr[each.key]
  availability_zone = each.value
  tags = {
    Name = "private subnet"
  }
}




##### create vpc endpoint/ gateway endpoint + route to endpoint 


#two subnet RDS 
# need to create et associate route table 

# resource "aws_subnet" "rds_private" {
#   for_each          = var.az
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.pri_sub_cidr[each.key]
#   availability_zone = each.value
#   tags = {
#     Name = "private rds subnet"
#   }
# }



# need to be duplicate according to architecture graph
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet"
  }
}





resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "ip" {
}


#to be complete maybe
resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.ip.id
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"            # destination
    nat_gateway_id = aws_nat_gateway.ngw.id #gateway
  }

  tags = {
    Name = "private rt"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = var.az
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}

# Security group
resource "aws_security_group" "alb_sg" {

  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }



  egress { # always set this ortherwise the outbound traffic is down 
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }

}