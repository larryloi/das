# What is DAS ?
This is a Core APP to archive data between 2 data storage base on configable conditions from opsta or HMS.

## How To Build a Image
Check out das repo in parent directory
```
git clone git@bitbucket.org:gamesource/das.git
```
Edit `RELEASE` after code change
Run the below command to build a image
```
docker build -f Dockerfile-base /docker/opsta/das -t das-base:0.1.0
docker run --rm -it --env-file bundler.env -v /docker/opsta/das:/app -v /root/.ssh:/root/.ssh -w /app das-base:0.1.0 bundle install
docker build -f Dockerfile-app /docker/opsta/das -t docker-repos:8123/chronos2/das:2.0.0-mysql8
```
OR make commands shortcuts here
```
make build-das
```

## How To Test on Local VM
It cannot test alone itself but also works with OPSTA or HMS archiver configuration

Check out das repo
```
git clone git@bitbucket.org:gamesource/das.git
```
Also Check out OPSTA or HMS archiver repo in parent directory
```
git clone git@bitbucket.org:gamesource/kilimanjaro-opsta.git
```

**Ensure the proper das version in Dockerfile**

Run the below script to start up docker env
```
bash ./scripts/start-docker-env.sh
```


## How to use this image
When deployed to any container environments, make sure the below environment variables are defined.
```
IMAGE=axle-opsta
TAG=1.3.0
REPO_PATH=docker-repos:8123/chronos2/

RECIPIENT='dba@gamesourcecloud.com,alert.ds@gamesourcecloud.com'
SMTP=hq-prd-mta-vapp01.laxino.local
SMTP_PORT=25

ENV=test1
CHECK_MINS=15
POOL_SIZE=1
MIGRATION_BASE=db/migrations

SRC_MYSQL_USER=chronos
SRC_MYSQL_PASSWORD=chronos
SRC_MYSQL_HOST=axle-db
SRC_MYSQL_PORT=3306
SRC_MYSQL_DATABASE=g2_axle_test1
SRC_SCHEMA_TABLE=schema_migrations
SRC_FRACTIONAL_SECONDS=false
SRC_ENCODING=utf8mb4
SRC_ENABLE_SQL_LOG=false


DST_MYSQL_USER=chronos
DST_MYSQL_PASSWORD=chronos
DST_MYSQL_HOST=opsta-db
DST_MYSQL_PORT=3306
DST_MYSQL_DATABASE=aino_opsta_test1
DST_SCHEMA_TABLE=schema_migrations
DST_FRACTIONAL_SECONDS=true
DST_ENCODING=utf8mb4
DST_ENABLE_SQL_LOG=false

#TESTING=1
#RETENTION_PERIOD_SMALL=7d
#RETENTION_PERIOD_MEDIUM=40d
#RETENTION_PERIOD_LARGE=180d
RETENTION_PERIOD_HUGE=3650d
TRACE_LOGS_RETENTION_PERIOD=3d
```
