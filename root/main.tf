module "vpc" {
  source   = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  pub_cidr = var.pub_cidr

}

module "SG" {
  source = "../modules/SG"
  vpc_id = module.vpc.vpc_id
}

module "Key" {
  source = "../modules/Key"
}

module "Ec2" {
  source = "../modules/EC2"
  sg_id = module.SG.sg_id
  pub_sub_id = module.vpc.pub_sub_id
  key_name = module.Key.key_name
}