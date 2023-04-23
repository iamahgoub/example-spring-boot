# example-spring-boot

This is an example of Spring Boot [Getting Started](https://github.com/spring-guides/gs-spring-boot/tree/c42d4edfec8e704431380b884f5cfed78f17e876/initial) modified to work on OpenJDK CRaC.

Changes: https://github.com/CRaC/example-spring-boot/compare/base..crac

## Building

Use maven to build
```
mvn package
```

## Running

Please refer to [README](https://github.com/CRaC/docs#users-flow) for details.

### Preparing the image
1. Run the [JDK](README.md#JDK) in the checkpoint mode
```
$JAVA_HOME/bin/java -XX:CRaCCheckpointTo=cr -jar target/spring-boot-0.0.1-SNAPSHOT.jar
```
2. Warm-up the instance
```
siege -c 1 -r 100000 -b http://localhost:8080
```
3. Request checkpoint
```
jcmd target/spring-boot-0.0.1-SNAPSHOT.jar JDK.checkpoint
```

### Restoring

```
$JAVA_HOME/bin/java -XX:CRaCRestoreFrom=cr
```

## Additional instructions

First, we will test CRaC in a Docker environment, then test it in a Kubernetes environment.

### Testing CRaC in a Docker container

Cloud9 will be used for running a sample springboot application restored using CRaC in a Docker container.


1. Install OpenJDK CRaC

A JDK that supports CRaC is required. Amazon Corretto is uninstalled, and [CRaC JDK](https://github.com/openjdk/crac) is installed to satisfy this requirement.

```
sudo yum remove java-11-amazon-corretto-headless.x86_64

echo 'export JAVA_HOME=/opt/jdk/openjdk-17-crac+5_linux-x64' >>  ~/.bash_profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >>  ~/.bash_profile
.  ~/.bash_profile

sudo mkdir /opt/jdk/
cd /opt/jdk/
cd $JAVA_HOME
sudo wget https://github.com/CRaC/openjdk-builds/releases/download/17-crac%2B3/openjdk-17-crac+3_linux-x64.tar.gz

sudo tar --extract --file openjdk-17-crac+3_linux-x64.tar.gz --directory .
```

2. Install Maven
```
cd ~/environment
wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz
tar xzvf apache-maven-3.9.1-bin.tar.gz
echo 'export PATH=/home/ec2-user/environment/apache-maven-3.9.1/bin:$PATH' >>  ~/.bash_profile
.  ~/.bash_profile
```

3.  Setup SSH keys for accessing GitHub, and clone the repository.
```
ssh-keygen -t ed25519 -C "<your-email-address>"
```

```
touch ~/.ssh/config
cat << EOF > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

```
cat ~/.ssh/id_ed25519.pub
```

```
git clone git@github.com:iamahgoub/example-spring-boot.git
```

4. Build container image, run it, and perform a checkpoint.

```
DOCKER_BUILDKIT=1 docker build -t example-spring-boot-crac .
docker run --detach --privileged --rm --name example-spring-boot-crac example-spring-boot-crac /opt/scripts/checkpoint.sh
```

5. Confirm that the snapshot has been taken successfully.

```
docker exec -u root example-spring-boot-crac /opt/scripts/checkpoint-wait.sh
```

6. Use `docker commit` to create a new container image with the checkpoint files included
```
docker commit example-spring-boot-crac example-spring-boot-crac:checkpoint
```

7. Run a container from the new container image, and restore the Java process from the checkpoint.

```
docker run --detach --privileged --rm --name example-spring-boot-crac example-spring-boot-crac /opt/scripts/run-service.sh
```

8. Test the restoration by checking logs, and by calling the springboot application HTTP endpoint.

### Using CodePipeline and CodeCommit for automating the checkpoint capture and images creation

Refer to `buildspec.yml`.

### Testing CRaC in Kubernetes environment

Refer to `k8s` directory.