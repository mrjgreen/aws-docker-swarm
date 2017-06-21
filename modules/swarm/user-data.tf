data "template_file" "user-data" {
  template = "${ file( "${ path.module }/user-data.sh" )}"

  vars {
    ROLE="${var.role}"
    SWARM_DISCOVERY_BUCKET="${var.discovery-bucket}"
  }
}
