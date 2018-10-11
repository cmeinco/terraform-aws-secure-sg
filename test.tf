# Template for initial configuration bash script
data "template_file" "init" {
  template = "${file("templates/secure-sg.tf")}"

  vars {
    homeip = "${data.http.checkip.body}"
  }
}

resource "local_file" "foo" {
    content     = "${data.template_file.init.rendered}"
    filename = "temp/main.tf"
}

data "http" "checkip" {
  #url = "http://checkip.amazonaws.com"
  #url = "http://ipv4.icanhazip.com"
  url = "http://whatismyip.akamai.com"

  # Optional request headers
  #request_headers {
  #  "Accept" = "application/text"
  #}
}
