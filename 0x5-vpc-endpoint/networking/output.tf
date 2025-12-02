output subnet_ids {
  value = {
    public_id = aws_subnet.public_subnet.id,
    private_id = aws_subnet.private_subnet.id
}
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output route_table_ids {
  value = {
    public_id = aws_route_table.public_route_table.id,
    private_id = aws_route_table.private_route_table.id
  }
}