resource "google_dns_record_set" "a_record" {
  name         = var.dns_name
  type         = var.dns_type
  ttl          = var.dns_ttl
  managed_zone = var.managed_zone
  rrdatas      = [google_compute_global_address.alb-static-ip.address]

  depends_on = [google_compute_global_forwarding_rule.forwarding-rule]
}

resource "google_dns_record_set" "mx_record" {
  name         = var.dns_name
  type         = "MX"
  ttl          = var.dns_ttl
  managed_zone = var.managed_zone
  rrdatas = [
    "10 mxa.mailgun.org.",
    "10 mxb.mailgun.org."
  ]
}

resource "google_dns_record_set" "spf_record" {
  name         = var.dns_name
  type         = "TXT"
  ttl          = var.dns_ttl
  managed_zone = var.managed_zone
  rrdatas      = ["v=spf1 include:mailgun.org ~all"]
}

resource "google_dns_record_set" "dkim_record" {
  name         = "krs._domainkey.eashanroy.me."
  type         = "TXT"
  ttl          = var.dns_ttl
  managed_zone = var.managed_zone
  rrdatas      = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDoNNTODNWiSEyf1nbsQEGp2/nznzljbn61ERJI+WAkORRUxkdzi13rS4PMXPsc4/Z9ScXdhAGp3mkXGlgZdo6FHLGA+Pf0caLDMPvH/vszXnZka9hJ3r92XAyBWeBo+rDtjFwp14Jsp2cMB2XymYIphUmO2JjfanRYCnjHAK7FLQIDAQAB"]
}
