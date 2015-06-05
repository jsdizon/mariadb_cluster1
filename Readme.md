### MariaDB cluster on Docker Container

To have the image available.
```
Docker pull jsdizon/mariadb_cluster1
```

To create the image.

```
git clone https://github.com/jsdizon/mariadb_cluster1.git

docker build -t mariadbcluster .

```

### Single Docker Server
Assuming we have a docker server, we will create a container using these commands to create a mariaDB cluster. The ip address of the docker server is not that important on this because the 3 containers will depend only on the hostname of the containers and the "--link" command in order to communicate with each other.

```
docker run -dP --name node1 -h node1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://

docker run -dP --name node2 -h node2 --link node1:node1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://node1

docker run -dP --name node3 -h node3 --link node1:node1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://node1
```


### 3 Docker Servers
The ip address of the servers are important here to be able to communicate with each other. To create a mariaDB cluster on 3 Docker servers just run these commands below. Assuming we have a 3 docker servers and the ip address of the servers are;

######Docker1 10.10.10.1
```
docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568  --name node1 -h node1 jsdizon/mariadb_cluster1 --wsrep-cluster-address=gcomm:// --wsrep-node-address=10.10.10.1
```
######Docker2 10.10.10.2
```
docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568 --name node2 -h node2 jsdizon/mariadb_cluster1 --wsrep-cluster-address=gcomm://10.10.10.1 --wsrep-node-address=10.10.10.2
```
######Docker3 10.10.10.3
```
docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568 --name node3 -h node3 jsdizon/mariadb_cluster1 --wsrep-cluster-address=gcomm://10.10.10.1 --wsrep-node-address=10.10.10.3
```

####### The good thing on cluster is that when one container is destroyed you will be able to create another container to replace it.

### Single Docker Server
On a single docker server it will base on the command "--wsrep-cluster-address=gcomm://", you need to specify it on where the new container will be joining on the cluster. For example the node1 is destroyed, the new container will be joining `node2` / `node3` and vice versa.

######node2
```
docker run -dP --name node1 -h node1 --link node2:node2 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://node2
```
######node3
```
docker run -dP --name node1 -h node1 --link node3:node3 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://node3
```
### 3 Docker Servers
With the same concept of the single docker server, the only difference is that on the command "--wsrep-cluster-address=gcomm://", you will specify the ip address of the docker server. As an example, see below;

  the container on `Docker1 10.10.10.1` is destroyed, the new container will be joining with `Docker2 10.10.10.2` or `Docker3 10.10.10.3`


### You can check the cluster by running this command on the running containers, just change the $node to the name of the running containers.
```
docker exec -ti $node mysql -e 'show status like "wsrep_cluster_size"'
```
If the result is 3, then the cluster is successfully created.
