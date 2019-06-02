data "aws_ami" "aws-kind-demo-most-recent-ami" {
  owners           = ["self"]
  most_recent      = true

  filter {
    name   = "tag:Event"
    values = ["Paris Container Day 2019"]
  }

  filter {
    name   = "tag:Project"
    values = ["Kind demo"]
  }
}

resource "aws_instance" "aws-kind-demo-instance" {
  ami           = "${data.aws_ami.aws-kind-demo-most-recent-ami.id}"
  instance_type = "t2.xlarge"

  key_name      = "xebia-achotard-mine"
  root_block_device = {
    volume_size = "80"
  }

  tags = {
    Event = "Paris Container Day 2019"
    Project = "Kind demo"
    Stage = "Demo"
  }
}

output "AWS - Instance IP" {
  value = "${aws_instance.aws-kind-demo-instance.public_ip}"
}

output "AWS - SSH command" {
  value = "ssh ubuntu@${aws_instance.aws-kind-demo-instance.public_ip}"
}
