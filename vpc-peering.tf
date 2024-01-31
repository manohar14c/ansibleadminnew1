# data "aws_vpc" "ansible_vpc" {
#   id   = "vpc-01525d8c90bf34d4b" 
# }


# data "aws_route_table" "ansible_vpc_rt" {
#   subnet_id   = "subnet-0d78442417af25a75" 
# }

# resource "aws_vpc_peering_connection" "manu" {
#   peer_vpc_id       = data.aws_vpc.ansible_vpc.id  
#   vpc_id            = aws_vpc.default.id 
#   auto_accept       = true 
#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   } 

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }         

#   tags = {
#     Name = "MyVpcPeeringConnection"
#   }
# }

# resource "aws_route" "peer_route" {
#   route_table_id            = aws_route_table.terraform-public.id  
#   destination_cidr_block    = "10.0.0.0/16"   
#   vpc_peering_connection_id = aws_vpc_peering_connection.manu.id  
# }

# resource "aws_route" "peeringfromansible" {
#   route_table_id            = data.aws_route_table.ansible_vpc_rt.id  
#   destination_cidr_block    = "10.35.0.0/16"   
#   vpc_peering_connection_id = aws_vpc_peering_connection.manu.id  
# }