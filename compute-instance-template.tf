resource "google_compute_instance_template" "webapp_template" {

  name_prefix = "webapp-instance-template-"
  //'name_prefix' is preferred over 'name' as 'create_before_destroy' will have conflict issues if trying to use the same name 
  //(we can't have two templates with the same name at the same time).

  machine_type = var.vm-size
  region       = var.vpc-region

  depends_on = [
    google_service_account.vm_service_account,
    google_project_iam_binding.logging_admin_binding,
    google_project_iam_binding.monitoring_metric_writer_binding,
    google_project_iam_binding.vm_pubsub_publisher
  ]

  disk {
    source_image = var.packer-image-path

    auto_delete = var.disk_auto_delete
    //Automatically deletes the boot disk when the instance is deleted, 
    //ensuring data associated with individual instances doesn't persist unnecessarily.

    boot = var.disk_boot
    //Indicates that this is a boot disk

    disk_size_gb = var.vm-storage
    disk_type    = var.vm-type
  }


  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.webapp.id
    //omitted 'access_config' block to make sure no external IPs are assigned to compute instances created via this template
    # access_config {
    #   // This block assigns an external IP
    # }
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = var.service-account-scope-vm
  }

  metadata = {
    db_host     = google_sql_database_instance.cloudsql_instance.private_ip_address
    db_name     = google_sql_database.webapp_database.name
    db_user     = google_sql_user.db_user.name
    db_password = random_password.db_password.result
    //startup-script-url = "gs://${var.startup_script_bucket}/${var.startup_script_object}"
  }

  metadata_startup_script = file("vm-startup-script.sh")
  can_ip_forward          = var.vm-can-ip-forward

  //'scheduling' block controls the preemption behavior and migration options during maintenance events.

  scheduling {
    automatic_restart = var.automatic_restart
    //If, for any reason, the system needs to terminate your instance (except for manual terminations or preemptible instance terminations), 
    //it will automatically restart it (if set to 'true')

    on_host_maintenance = var.on_host_maintenance
    //Instance will be seamlessly migrated to another host before maintenance activity starts to minimize downtime (if set to 'MIGRATE')

    preemptible = var.preemptible
    //Although preemptible instances are cheaper, they can be terminated at any moment by GCP like spot instances in AWS, which is not ideal
    //for a stable and high availability setup. (hence, set to 'false')
  }

  lifecycle {
    // The create_before_destroy lifecycle attribute in Terraform ensures that the new version of the resource is created and operational 
    // before attempting to destroy the old version
    create_before_destroy = true
  }

  tags = var.vm-tags
  //tags are used here to apply firewall rules
}
