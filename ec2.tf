resource "aws_instance" "webservers" {
  count                       = local.new_environment == "production" ? 3 : 1
  ami                         = "ami-06aa3f7caf3a30282"
  instance_type               = lookup(var.instance_type, local.new_environment)
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.public-subnets.*.id, count.index)
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name              = "${var.vpc_name}-PublicServer-${count.index + 1}"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
  
  user_data = <<-EOT
 #!/bin/bash
   "sudo useradd -m ansibleadmin --shell /bin/bash" 
   "sudo mkdir -p /home/ansibleadmin/.ssh" 
   "sudo chown -R ansibleadmin /home/ansibleadmin/" 
   "sudo touch /home/ansibleadmin/.ssh/authorized_keys 
   "sudo usermod -aG sudo ansibleadmin"
   "echo 'ansibleadmin ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers" 
   "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNOpPl3F7nxpMBd0q+4tr0UpHa0ikhyjjWylsAPbn3PLiAbm0IpuBzgX2nkwQaMHLg5YcxhWvETGBNMnjzA6yNL/qWDvitL6MrKc+Be6XTdFxtTSFPBekEtfJC6Gn1Iw0BLWZzA7EIoh3Xnzhr3DAxlcBzVv0IUiFxIOfz/PKektHWAzC38mjcIqKpawiIsFQwvp/aXftbGm/7gtzykJWAtq9aLDff+5kufAsdlaKowxz+qDFowagx183C/So3y2f6zn7dT5PqNAE/jj+jx4adIjNMn+tbaKTtw5Dq/g23WgbAHXQTZemZ2t+DsY8vvCqshBM9M/DBGt8bYD0SehZnS/D/CiVr6sGR055LDQMSaQ6dRRfKbZCPPytYqOLCAfgGdNydCLkuyy47HtX5iCTbfkwJMzin2cTCNWbRctAtRIx5Wp7QHuv359qIPWiKk4UjZPdKih3rA5qleBe9VClkeI/W9N0APOZPeuhOj8GoaAyDf7XNqMiXzf1ohC1rEY8' | sudo tee /home/ansibleadmin/.ssh/authorized_keys"
  EOT
}

