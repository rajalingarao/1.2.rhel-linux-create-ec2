resource "aws_instance" "rhel_create_ec2" {
    ami           = data.aws_ami.rhel_info.id
    instance_type = var.ec2_instance.instance_type
    vpc_security_group_ids = [var.allow_everything]
    root_block_device {
        encrypted             = false
        volume_type           = "gp3"
        volume_size           = 30
        iops                  = 3000
        throughput            = 80
        delete_on_termination = true
    }
    tags = {
        Name = "rhel_ec2_server"
    }
}
resource "aws_route53_record" "rhel_r53" {
    zone_id = var.zone_id
    name    = "rhel_ec2.${var.domain_name}"
    type    = "A"
    ttl     = 1
    records = [aws_instance.rhel_create_ec2.public_ip]
    allow_overwrite = true
}


