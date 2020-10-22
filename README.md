### Nomad Blue-Green PoC


## Requirements

* Nomad
* Docker

## Install Nomad

* cd /tmp
* wget https://releases.hashicorp.com/nomad/0.12.5/nomad_0.12.5_linux_amd64.zip
* unzip nomad_0.12.5_linux_amd64.zip
* sudo install -m 775 nomad /usr/bin/nomad
* hash -r

## Run samples

* nomad job init consul.nomad
* nomad job init haproxy.nomad
* nomad job init http-echo.nomad ( Might stay in pending for couple of seconds until Consul boots up)


#  Simulate job update

In `http-eecho.nomad` task , replace YOUR_VERSION key, and run `nomad job init http-echo.nomd`

```
task "app" {

    driver = "docker"
    config {
        image = "hashicorp/http-echo"
        args = ["-text", "{ \"version\": \"YOUR_VERSION\", \"port\": \"${NOMAD_PORT_http}\" }", "-listen", "0.0.0.0:${NOMAD_PORT_http}" ]
    }

}
```
## Monitoring


Test in two splitted terminals

Live traffic 

```
while :; do echo "$(date) $(curl -s -o  -w '%{http_code}' $YOUR_IP)" ; sleep 1 ; done
```


Canary traffic 
```
while :; do echo "$(date) $(curl -s -o  -w '%{http_code}' $YOUR_IP:8080)" ; sleep 1 ; done
```

## Testing

New version of app are available on port 8080. After testing is done, you can promote deployment over UI or CLI.