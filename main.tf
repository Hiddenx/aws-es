variable "region" {
}
variable "vpc_id" {
}

variable "vpc_cidr_block" {
}

variable "es_domain" {
}

variable "es_subnets" {
  type = "list"
}

variable "es_version" {
}

variable "instance_count" {
}

variable "instance_type" {
}

variable "master_instance_type" {
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "es_sg" {
  name = "${var.es_domain}-SecurityGroup"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "all"
      cidr_blocks = [
          "${var.vpc_cidr}"
      ]
  }
}

resource "aws_elasticsearch_domain" "test-es" {
  domain_name = "${var.es_domain}"
  elasticsearch_version = "${var.es_version}"

  cluster_config {
      dedicated_master_enabled = "true"
      dedicated_master_type = "${var.master_instance_type}"
      dedicated_master_count = "1"
      instance_type = "${var.instance_type}"
      instance_count = "${var.instance_count}"
  }

  vpc_options {
      subnet_ids = "${var.es_subnets}"
      security_group_ids = [
          "${aws_security_group.es_sg.id}"
      ]
  }

  ebs_options {
      ebs_enabled = true
      volume_size = 50
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
      }
  ]
}
  CONFIG

output "ElasticSearch Endpoint" {
  value = "${aws_elasticsearch_domain.es.endpoint}"
}

}