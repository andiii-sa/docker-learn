docker image ls
docker image pull redis:latest
# delete image
docker image rm alpine:latest 

--
#  all container on & off
docker container ls -a

# all container on
docker container ls

# create container
docker container create --name contohredis redis:latest

# running container
docker container start idcontainer/namecontainer

# Stopping container
docker container stop idcontainer/namecontainer

# Delete container
docker container rm idcotnainer/namecontainer

# Lihat log container
docker container logs idcontainer/namecontainer

# Lihat log realtife container
docker container logs -f idcontainer/namecontainer

# Docker Exec - masuk container
docker container exec -i -t idcontainer/namacontainer /bin/bash

# Container port
# Port forwardding
docker container create --name namacontainer --publish posthost:portcontainer image:tag
posthost -> export port ex: 3000
portcontainer -> port container image ex: 6739

ex:
docker pull nginx:latest
docker container create --name contohnginx --publish 8080:80 nginx:latest
-> can access via localhost:8080

# Container environment variable
# Add env variable
docker container create --name contohmongo --publish 27017:27017 --env MONGO_INITDB_ROOT_USERNAME=eko --env MONGO_INITDB_ROOT_PASSWORD=eko mongo:latest

# Container stats
docker container stats

# Container resource limit
docker container create --name smallnginx --publish 8081:80 --memory 100m --cpus 0.5 nginx:latest

# Bind mounts - binding / sharing
docker container create --name namacontainer --mount "type=bind,source=folder,destination=folder,readonly" image:tag

docker container create --name mongodata --mount "type=bind,source=/Users/Andi/mongo-data,destination=/data/db" --publish 27018:27017 --env MONGO_INITDB_ROOT_USERNAME=eko --env MONGO_INITDB_ROOT_PASSWORD=eko mongo:latest

# Docker volume - lihat
docker volume ls

# Membuat volume
docker volume create mongovolume

# Hapus volume
docker volume rm mongovolume

# Container volume
docker volume create mongodata
docker container create --name mongovolume --mount "type=volume,source=mongodata,destination=/data/db" --publish 27019:27017 --env MONGO_INITDB_ROOT_USERNAME=eko --env MONGO_INITDB_ROOT_PASSWORD=eko mongo:latest

#### Docker Backup volume 
docker container create --name nginxbackup --mount "type=bind,source=d/Full Stack Developer/Docker/belajar-docker-dasar,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" nginx:latest
docker container start nginxbackup
docker container exec -i -t nginxbackup /bin/bash
tar cvf /backup/backup.tar.gz /data
docker container stop nginxbackup
docker container rm nginxbackup
docker container start mongovolume

# backup dengan container run
docker image pull ubuntu:latest
docker container stop mongovolume
docker container run --rm --name ubuntubackup --mount "type=bind,source=d/Full Stack Developer/Docker/backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" ubuntu:latest tar cvf /backup/backup2.tar.gz /data
docker container start mongovolume

# Restore backup volume
docker volume create mongorestore
docker container run --rm --name ubunturestore --mount "type=bind,source=d/Full Stack Developer/Docker/backup,destination=/backup" --mount "type=volume,source=mongorestore,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backup2.tar.gz --strip 1"

docker container create --name mongorestore --mount "type=volume,source=mongorestore,destination=/data/db" --publish 27020:27017 --env MONGO_INITDB_ROOT_USERNAME=eko --env MONGO_INITDB_ROOT_PASSWORD=eko mongo:latest


# List Docker Network
docker network ls

# Create network
docker network create --driver namadriver namanetwork
docker network create --driver bridge contohnetwork

# delete network -> network tidak bisa dihapus jika sudah digunakan oleh container
docker network rm namanetwork
docker network rm contohnetwork


# Container Network
# Create container dengan network
docker network create --driver bridge mongonetwork
docker container create --name mongodb --network mongonetwork --env MONGO_INITDB_ROOT_USERNAME=eko --env MONGO_INITDB_ROOT_PASSWORD=eko mongo:latest
docker image pull mongo-express:latest
docker container create --name mongodbexpress --network mongonetwork --publish 8081:8081 --env ME_CONFIG_MONGODB_URL="mongodb://eko:eko@mongodb:27017/" mongo-express:latest
docker container start mongodb
docker container start mongodbexpress

# delete container from network
docker network disconnect namanetwork namacontainer
docker network disconnect mongonetwork mongodb

# add container ke network
docker network connect namanetwork namacontainer
docker network connect mongonetwork mongodb

## Inspect
docker image inspect namaimage
docker container inspect namacontainer
docker volume inspect namavolume
docker network inspect namanetwork

## Prune -> menghapus yg sudah tidak digunakan
docker image prune
docker container prune
docker volume prune
docker network prune

# delete contaner, image, network
docker system prune

# !!!!!!!!!!!
### DOCKER FILE
# from Instruction
docker build -t sarasvati/from from

# run instruction
docker build -t sarasvati/run run
docker build -t sarasvati/run run --progress=plain --no-cache

# show include images sarasvati
docker image ls | grep sarasvati

# cmd instruction
docker build -t sarasvati/command command
docker image inspect sarasvati/command
docker container create --name command sarasvati/command
docker container start command
docker container logs command

# label instruction
docker build -t sarasvati/label label
docker image inspect sarasvati/label

# add instruction
docker build -t sarasvati/add add
docker container create --name add sarasvati/add
docker container start add
docker container logs add

# !!!!! 
# DOCKER COMPOSE
# in folder example
docker compose create

# running all container in folder example
docker compose start

# melihat container in folder example
docker compose ps

# stop container in folder example
docker compose stop

# delete container in folder example
docker compose down


# ~~~~~~
# TUTOR DEAFRIZAL
docker build -t react-zulkit-image:latest .
docker run -d -p 3000:3000 react-zulkit-image:latest


# ~~~~~~
# DOCKER DEPLOY REACT JS
# build docker
docker build -t react-zulkit-image .
docker run -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest
docker exec -it react-zulkit bash

# Bind mounts, Sync local directory to docker container
docker run -e CHOKIDAR_USEPOLLING=true -v %cd%\src:/app/src -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest
docker run -e CHOKIDAR_USEPOLLING=true -v ${pwd}\src:/app/src -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest
# ${pwd} powershell/unix
# %cd%\  cmd only windows

# readonly container
docker run -e CHOKIDAR_USEPOLLING=true -v ${pwd}\src:/app/src:ro -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest

# delete container
docker rm react-zulkit -f

# add env
docker run -e CHOKIDAR_USEPOLLING=true -e REACT_APP_NAME=sanjeey -v ${pwd}\src:/app/src:ro -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest

# use current env
docker run --env-file ./.env -v ${pwd}\src:/app/src:ro -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest

docker run -it --env-file ./.env -v ${pwd}\src:/app/src:ro -d -p 4000:3000 --name react-zulkit react-zulkit-image:latest

# docker compose up
docker-compose up -d

# rebuild
docker-compose up -d --build

# docker compose down
docker-compose down

# build spesifik Dockerfile .dev
docker build -f Dockerfile.dev .

# build spesifik Dockerfile .prod
docker build -f Dockerfile.prod -t react-zulkit-image-prod .

docker run -it --env-file ./.env -d -p 8080:80 --name react-zulkit-prod react-zulkit-image-prod:latest

docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d --build
docker-compose -f docker-compose.yml -f docker-compose-dev.yml down

docker-compose -f docker-compose.yml -f docker-compose-prod.yml up -d --build

# target build
docker build --target build -f Dockerfile.prod -t multi-stage-example .


