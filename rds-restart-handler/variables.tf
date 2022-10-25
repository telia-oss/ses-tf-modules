variable "tags" {
  type    = map(string)
  default = {}
}

variable "rds_ecs_map" {
  description = "Mapping between RDS and RDS"
  type = list(object({
    rds_instance = string
    ecs_cluster  = string
    ecs_services = list(string)
  }))
}

#for example
#  rds_ecs_map = [
#    {
#      rds_instance = "my-rds-instance"
#      ecs_cluster = "my-ecs-cluster"
#      ecs_services = ["my-ecs-service-1", "my-ecs-service-2"]
#    },
#  ]
