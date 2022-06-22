resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block                = var.DEFAULT_VPC_CIDR
    vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.ENV}-pub-route-table"
  }
  
}

resource "aws_route_table_association" "public-rt-assoc" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

# resource "aws_route_table" "private-route-table" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block                = var.DEFAULT_VPC_CIDR
#     vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
#   }

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.ngw.id
#   }

#   tags = {
#     Name = "${var.ENV}-priv-route-table"
#   }
#   depends_on = [aws_nat_gateway.ngw]
# }


# resource "aws_route_table_association" "private-rt-assoc" {
#   count          = length(aws_subnet.private.*.id)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
#   route_table_id = aws_route_table.private-route-table.id
# }

# resource "aws_route" "route-to-default-vpc-rt" {
#   route_table_id            = var.DEFAULT_VPC_RT
#   destination_cidr_block    = var.VPC_CIDR
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer-connection.id
# }
