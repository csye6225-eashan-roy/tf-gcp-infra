resource "google_compute_region_instance_group_manager" "webapp-mig" {
  name                      = "webapp-mig-${random_string.resource_name.result}"
  base_instance_name        = var.mig_base_instance_name
  region                    = var.vpc-region
  distribution_policy_zones = var.distribution_policy_zones

  target_size = 4 //target number of running instances for this managed instance group
  depends_on  = [google_compute_instance_template.webapp_template]
  lifecycle {
    //The 'target_size' value will fight with autoscaler settings when set, and generally shouldn't be set when using one. 
    //If a value is required, such as to specify a creation-time target size for the MIG, 
    //lifecycle.ignore_changes can be used to instruct Terraform to ignore changes to this attribute after the initial creation.
    ignore_changes = [target_size]
  }

  version {
    instance_template = google_compute_instance_template.webapp_template.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp_health_check.self_link
    initial_delay_sec = var.mig_initial_delay_sec
    //The number of seconds the MIG waits before it applies autohealing policies to new instances
  }

  //update_policy block within a Google Cloud Managed Instance Group (MIG) resource configuration specifies 
  //how the group should handle updates and replacements of its instances, when the instance template of the MIG is changed.

  update_policy {

    type = "PROACTIVE"
    //MIG 'proactively' executes actions in order to bring instances to their target template version

    instance_redistribution_type = "PROACTIVE"
    //MIG attempts to maintain an even distribution of VM instances across all the zones in the region

    minimal_action = "REPLACE"
    //'REFRESH' updates without stopping existing instances,
    //'RESTART' updates by restarting existing instances,
    //'REPLACE' updates by deleting and recreating existing instances

    most_disruptive_allowed_action = "REPLACE"
    //Specifies the most disruptive action that is allowed to be taken on an instance
    //'REPLACE' is the most aggressive action

    max_surge_fixed = 3
    // Allows for one additional instance during updates

    max_unavailable_fixed = 3
    // Ensures no instances are unavailable during update
  }

  //Port mapping
  named_port {
    name = var.application_port_name
    //This name given to the 'named_port' in the MIG must match the 'port_name' in the 'google_compute_backend_service'
    port = var.port-8081
  }

}

//AUTOSCALER
resource "google_compute_region_autoscaler" "webapp-autoscaler" {
  name   = "webapp-autoscaler-${random_string.resource_name.result}"
  target = google_compute_region_instance_group_manager.webapp-mig.id

  autoscaling_policy {
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas

    cooldown_period = var.cooldown_period
    //The number of seconds that the autoscaler should wait before it starts collecting information from a new instance. 
    //This prevents the autoscaler from collecting information when the instance is initializing, during which the collected usage would not be reliable

    cpu_utilization {
      target = var.target_cpu_utilization
    }
  }
}
