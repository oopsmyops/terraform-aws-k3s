provider "aws" {
  region = local.region
  # ignore_tags {
  #   keys = ["creation_date"]
  # }
}

provider "external" {
}