resource "aws_instance" "strapi" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("user_data.sh")

  tags = {
    Name = "${var.project_name}-ec2"
    Env  = var.environment
  }
}