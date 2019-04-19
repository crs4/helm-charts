# Apache Flink Chart
Apache Flink is a framework and distributed processing engine for stateful computations over unbounded and bounded data streams.
Flink has been designed to run in all common cluster environments, perform computations at in-memory speed and at any scale.

## Chart Configuration

| Parameter               | Description                                           | Default          |
| :---------------------- |:-------------------------------                       | :--------------- |
| `replicaCount`          | pod replicas                                          | `1`              |
| `image.repository`      | container image                                       | `flink`          |
| `image.tag`             |                                                       | `1.4.2`          |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`          |
| `ingress.annotations`   | Ingress annotations                                   | `[]`             |
| `ingress.hosts`         | Hostnames                                             |                  |
| `ingress.path`          | Path within the url structure                         | `/`              |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`             |
| `image.pullPolicy`      |                                                       | `IfNotPresent`   |
| `service`               |                                                       | `ClusterIP`      |
| `resources`             | Resource requests & limits                            | `{}`             |
| `conf`                  | the flink-conf.yaml, excluded ports (defined in `ports`)  |              |
| `ports`                 | flink ports                                          |                  |

