output "manager-autoscaling-group-name" {
  value = "${ module.manager.autoscaling-group-name }"
}

output "autoscaling-group-names" {
  value =  [
    "${ module.manager.autoscaling-group-name }",
    "${ module.worker.autoscaling-group-name }"
  ]
}
