
module "exocom-service" {
  source = "./exocom"

  name = "exosphere-exocom"
  cluster_id = "${module.exocom-cluster.cluster_id}"
}

resource "aws_route53_record" "exocom" {
   zone_id = "${var.hosted_zone_id}"
   name = "{{exocomDns}}"
   type = "A"
   ttl = "300"
   records = ["${module.exocom-cluster.exocom_ip}"]
}
