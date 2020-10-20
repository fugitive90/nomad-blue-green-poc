job "consul" {

    datacenters = ["dc1"]
    group "local" {
        task "consul" {

            driver = "exec"
            config {
                command = "consul"
                args = ["agent", "-dev" ,"-log-level=INFO"]
            }

        }
    }
}

 