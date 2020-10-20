job "test" {

    datacenters = ["dc1"]
    group "app" {
        
        count = 3

        service {
            name = "http"
            port = "http"      
            // connect {
            //     sidecar_service {}
            // }     
            tags = ["blue"]
            canary_tags = ["green"]    
            enable_tag_override = true    
            connect { sidecar_service { }
                
             }     
        }

        network {
            mode = "bridge"
            
            port "http" {}
        }
        update {
            max_parallel     = 3
            canary           = 3
            min_healthy_time = "30s"
            healthy_deadline = "5m"
            progress_deadline = "10m"
            auto_revert      = true
            auto_promote     = false
        }
        task "app" {

            driver = "docker"
            config {
                image = "hashicorp/http-echo"
                
                args = ["-text", "v1.9 @ ${NOMAD_PORT_http}", "-listen", "0.0.0.0:${NOMAD_PORT_http}" ]
            }

        }
    }
}