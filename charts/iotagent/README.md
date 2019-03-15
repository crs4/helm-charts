# Iotagent-json Helm Chart
An Internet of Things Agent for a JSON based protocol (with AMQP, HTTP and MQTT transports). This IoT Agent is designed to be a bridge between JSON and the NGSI interface of a context broker. For more information, see <https://github.com/telefonicaid/iotagent-json>.

## Chart Configuration


| Parameter               | Description                                           | Default                |
| :---------------------- |:-------------------------------                       | :--------------------  |
| `replicaCount`          | pod replicas                                          | `1`                    |
| `image.repository`      | container image                                       | `crs4/iotagent-json`   |
| `image.tag `            |                                                       | `"1.0"`                |
| `image.pullPolicy`      |                                                       | `IfNotPresent`         |
| `service.type`          |                                                       | `ClusterIP`            |
| `service.port`          |                                                       | `4041`                 |
| `services`              | A yaml containing services to create. See the related\
                            paragraph for more info                               |                        |
| `mqtt.username`         | username for mqtt                                     |                        |
| `mqtt.password`         | password for mqtt                                     |                        |
| `mqtt.keepalive`        | keepalive for mqtt connection                         | `5`                    |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`                |
| `ingress.annotations`   | Ingress annotations                                   | `[]`                   |
| `ingress.hosts`         | Hostnames                                             |                        |
| `ingress.path`          | Path within the url structure                         | `/`                    |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`                   |
| `image.pullPolicy`      |                                                       | `IfNotPresent`         |
| `resources`             | Resource requests & limits                            | `{}`                   |
|

### Services creation
`services` field `in values.yaml` allows to create services as the iotagent is up. It accepts a list       of objects, each one related to a service and with the following mandatory fields:

 - fiware_service
 - fiware_service_path
 - description

`Description` is the json accepted by iotagent server call for service  ( POST to `/iot/services`).
Here is an example:
```
    - fiware_service: a_service
      fiware_service_path: /some/path
      description: {
        "services": [
          {
            "apikey": "1234",
            "entity_type": "Entity",
            "resource": "/a/resource",
            "attributes": [
              {
                "object_id": "some_object",
                "name": "ObjectName",
                "type": "String"
              }
            ]
          }
        ]
      }

```
