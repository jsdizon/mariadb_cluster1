### MariaDB cluster with Galera on Ubuntu 14.04



### Single Docker Server
Assuming we have a Docker server and we will create a container using these commands to create a mariaDB cluster, ip address of the Docker server is not that important on this because the 3 containers will depend only on the hostname of the containers and the "--link" command in order to communicate with each other.

##docker run -dP --name db1 -h db1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://

##docker run -dP --name db2 -h db2 --link db1:db1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://db1

##docker run -dP --name db3 -h db3 --link db1:db1 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://db1



### 3 Docker Servers
The ip address of the servers are important here to be able to communicate with each other. To create a mariaDB cluster on 3 Docker servers just run these commands below. Assuming we have a 3 Docker servers and the ip address of the servers are;

*Docker1 10.15.100.231
##docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568  --name node1 -h node1 jsdizon/mariadb_cluster1 --wsrep-cluster-address=gcomm:// --wsrep-node-address=10.15.100.231

*Docker2 10.15.100.232
##docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568 --name node2 -h node2 jsdizon/mariadb_cluster2 --wsrep-cluster-address=gcomm://10.15.100.231 --wsrep-node-address=10.15.100.232

*Docker3 10.15.100.233
##docker run -d -p 3306:3306 -p 4444:4444 -p 4567:4567 -p 4568:4568 --name node3 -h node3 jsdizon/mariadb_cluster3 --wsrep-cluster-address=gcomm://10.15.100.231 --wsrep-node-address=10.15.100.233


### The good thing on the cluster is when one container was destroyed you will be able to create another container to switch on it,

### Single Docker Server
On a single Docker server it will base on the command "--wsrep-cluster-address=gcomm://", you need to specify on it where the new container will be joining on the cluster. For example the db1 was destoryed, the new container will be joining to db2 or db3 and vice versa.

*db2
docker run -dP --name db1 -h db1 --link db2:db2 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://db2

*db3
docker run -dP --name db1 -h db1 --link db3:db3 jsdizon/mariadb_cluster1 --wsrep-cluster-name=galera_cluster --wsrep-cluster-address=gcomm://db3

### 3 Docker Servers
Same the concept on single Docker server, but the difference is that on the command "--wsrep-cluster-address=gcomm://", you will specify the ip address of the Docker server. For example the container on *Docker1 10.15.100.231 was destroyed, the new container will be joining on the *Docker2 10.15.100.232 or *Docker3 10.15.100.233 and vice versa.


### You can check the cluster by running this command on the running containers, just change the $DB to the name of the running containers.

##docker exec -ti $DB mysql -e 'show status like "wsrep_cluster_size"'

If the result is 3, then the cluster was successfully created.
