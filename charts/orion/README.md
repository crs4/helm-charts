# Fiware Orion Helm Chart

Orion is a C++ implementation of the NGSIv2 REST API binding developed as a part of the FIWARE platform.

## Chart Configuration

| Parameter               | Description                                           | Default                |
| ----------------------- | -------------------------------                       | ---------------------- |
| `replicaCount`          | pod replicas                                          | `1`                    |
| `image.repository`      | container image                                       | `fiware/orion`         |
| `image.tag`             |                                                       | `2.0.0`                |
| `image.pullPolicy`      |                                                       | `IfNotPresent`         |
| `service.type`          |                                                       | `ClusterIP`            |
| `service.port`          |                                                       | `1026`                 |
| `cygnus. url`           | Cygnus url, for subscription creation                 |                        |
| `cygnus.subscriptions`  | Cygnus subscriptions, creted as the service is \
                            created. See the related paragraph for more info      |                        |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`                |
| `ingress.annotations`   | Ingress annotations                                   | `[]`                   |
| `ingress.hosts`         | Hostnames                                             |                        |
| `ingress.path`          | Path within the url structure                         | `/`                    |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`                   |
| `image.pullPolicy`      |                                                       | `IfNotPresent`         |
| `resources`             | Resource requests & limits                            | `{}`                   |

### Cygnus subscriptions
`cygnus.subscriptions` field `in values.yaml` allows to create subscriptions as Orion goes up. It accepts a list of objects, each one related to a subscription and with the following mandatory fields:

 - fiware_service
 - fiware_service_path
 - description

`Description` is the json accepted by iotagent server call for service  ( POST to `/iot/services`).
Here is an example:
```
  - fiware_service: a_service
    fiware_service_path: /some/path
    description: {
        "description": "A subscription",
        "subject": {
          "entities": [
            {
              "idPattern": ".*",
              "type": "Type"
            }
          ],
          "condition": {
            "attrs": []
          }
        },
        "notification": {
          "http": {
            "url": "http://{{ .Release.Name }}-cygnus:{{ .Values.cygnus.port }}/notify"
          },
          "attrs": [],
          "attrsFormat": "legacy"
        }
      }

```

Note that template calls can be used in cygnus.subscriptions, like  .Release.Name  or  .Values.some_value. .Values call in cygnus.subscriptions from a parent chart must be used as defined inside Orion values. Cygnus service name is expected to be {{ .Release.Name }}-cygnus.


