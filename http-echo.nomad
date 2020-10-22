job "test" {

    datacenters = ["dc1"]
    group "app" {
        
        count = 5


        service {
            name = "http"
            port = "http"      
    
            tags = ["live"]
            canary_tags = ["canary"]   
        check {
          type     = "http"
          port     = "http"
          path = "/test"
          interval = "5s"
          timeout  = "1s"
        }

            // connect { sidecar_service {} }     
        }

        network {
            mode = "bridge"
            port "http" {}
        }
        update {
            max_parallel     = 1
            canary           = 1
            min_healthy_time = "15s"
            healthy_deadline = "5m"
            progress_deadline = "10m"
            auto_revert      = true
            auto_promote     = false
        }
        task "app" {

            driver = "docker"
            config {
                image = "hashicorp/http-echo"
                args = ["-text", "{ \"version\": \"v1.26\", \"port\": \"${NOMAD_PORT_http}\" }", "-listen", "0.0.0.0:${NOMAD_PORT_http}" ]
            }

        }
    }
}