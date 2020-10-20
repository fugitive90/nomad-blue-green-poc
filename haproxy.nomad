job "haproxy" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "haproxy" {
    count = 1


    task "haproxy" {
      driver = "docker"

      config {
        image        = "haproxy:2.0"
        network_mode = "host"

        volumes = [
          "local/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg",
        ]
      }

      template {
        data = <<EOF
defaults
    mode http
    log global
    
    timeout connect 5s
    timeout client  50s
    timeout server  50s

frontend stats
   bind *:1936
   stats uri /
   stats show-legends
   no log

frontend front


    mode http
    #option tcplog
    timeout client 1m
    no option http-server-close
    bind :80
    default_backend app

frontend canary
    mode http
    #option tcplog
    timeout client 1m
    no option http-server-close
    bind :8080
    default_backend canary


backend app

    option forwardfor
    mode http
    #no option http-server-close
    timeout server 1m
    timeout connect 5s    
    balance roundrobin
    server-template flask 10 _http._tcp.service.consul. resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4  check
    #server-template flask 10 blue.http.service.consul. resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4  


backend canary

    option forwardfor
    mode http
    #no option http-server-close
    timeout server 1m
    timeout connect 5s    
    balance roundrobin

    server-template canary 10 _http._tcp.service.consul. resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4  check
    #server-template canary 10 green.http.service.consul. resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4  


resolvers consul
  nameserver consul 127.0.0.1:8600
  accepted_payload_size 8192
  hold valid 30s
EOF

        destination = "local/haproxy.cfg"
  }


      resources {
        cpu    = 50
        memory = 128

        network {
          mbits = 10

          port "http" {  static = 80    }
           
        }
      }
    }
  }
}