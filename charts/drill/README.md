# Using drill and grafana
Apache Drill is an open-source software framework that supports data-intensive distributed applications for interactive analysis of large-scale datasets.

## Chart Configuration
| Parameter               | Description                                           | Default                     |
| :---------------------- |:-------------------------------                       | :------------------------   |
| `replicaCount`          | pod replicas                                          | `1`                         |
| `image.repository`      | container image                                       | `drill/apache-drill`        |
| `image.tag`             |                                                       | `1.14.0`                    |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`                     |
| `ingress.annotations`   | Ingress annotations                                   | `[]`                        |
| `ingress.hosts`         | Hostnames                                             |                             |
| `ingress.path`          | Path within the url structure                         | `/`                         |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`                        |
| `image.pullPolicy`      |                                                       | `IfNotPresent`              |
| `service`               |                                                       | `ClusterIP`                 |
| `resources`             | Resource requests & limits                            | ``{}`                       |
| `image.pullPolicy`      |                                                       | `IfNotPresent`              |
| `service.type`          |                                                       | `ClusterIP`                 |
| `service.port`          |                                                       | `8047`                      |
| `storage_plugins`       | List of storge plugins with filename and json conf    |                             |

## Grafana
In order to use drill a grafana, a datasource plugin is required: https://github.com/benkindt/grafana-drill-datasource.git

Mount the git repo on /var/lib/grafana/plugins.

Here is a example of a  docker-compose service:

```
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - 3000:3000
    volumes:
      - .:/var/lib/grafana/plugins/
```

Storage plugin examples (hdfs):
```
storage_plugins:
  - filename: hdfs.sys.drill
    conf: {
        "type": "file",
        "connection": "hdfs://{{ .Release.Name }}-hadoop-hdfs-nn:9000",
        "config": null,
        "workspaces": {
          "root": {
            "location": "/",
            "writable": false,
            "defaultInputFormat": null,
            "allowAccessOutsideWorkspace": false
          }
        },
        "formats": {
          "parquet": {
            "type": "parquet"
          }
        },
        "enabled": true
```
