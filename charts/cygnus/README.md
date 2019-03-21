# Fiware Cygnus Chart
Cygnus is a connector in charge of persisting context data sources into other third-party databases and storage systems,
creating a historical view of the context. Internally, Cygnus is based on Apache Flume, Flume is a data flow system based
on the concepts of flow-based programming. It supports powerful and scalable directed graphs of data routing, transformation,
and system mediation logic. It was built to automate the flow of data between systems. While the term 'dataflow' can be used
in a variety of contexts, we use it here to mean the automated and managed flow of information between systems.

Each data persistence agent within Cygnus is composed of three parts - a listener or source in charge of receiving the data,
a channel where the source puts the data once it has been transformed into a Flume event, and a sink, which takes Flume
events from the channel in order to persist the data within its body into a third-party storage.

This project is part of FIWARE. For more information check the FIWARE Catalogue entry for the Core Context Management.


## Chart Configuration

| Parameter               | Description                                           | Default                     |
| :---------------------- |:-------------------------------                       | :------------------------   |
| `replicaCount`          | pod replicas                                          | `1`                         |
| `image.repository`      | container image                                       | `fiware/cygnus-ngsi`        |
| `image.tag`             |                                                       | `0.1`                       |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`                     |
| `ingress.annotations`   | Ingress annotations                                   | `[]`                        |
| `ingress.hosts`         | Hostnames                                             |                             |
| `ingress.path`          | Path within the url structure                         | `/`                         |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`                        |
| `image.pullPolicy`      |                                                       | `IfNotPresent`              |
| `service`               |                                                       | `ClusterIP`                 |
| `resources`             | Resource requests & limits                            | `{}`                       |
| `image.pullPolicy`      |                                                       | `IfNotPresent`              |
| `service.type`          |                                                       | `ClusterIP`                 |
| `service.port`          |                                                       | `5050`                      |
| `conf.agentConf`        | Text containing the agent configuration. You can use template call like  .Release.Name  or .Values.avalue.  |                             |
| `conf.flumeEnv`         | Text containing the environment variables for the JVM |                             |




