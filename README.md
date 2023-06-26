# What is DAS ?
This is a Core APP to archive data between 2 data storage base on configable conditions from opsta or HMS.

## How To Build a Image
Check out das repo in parent directory
```
git clone git@github.com:larryloi/das.git
```
Confirm you release version in das/docker/RELEASE
Run the below command to build a image
```
cd das/docker
make bundle-install
make build
```
OR make commands shortcuts here
```
make build-das
```

## How To Test on Local VM
It cannot test alone itself but also works with OPSTA or HMS archiver configuration

Check out das repo
```
git clone git@github.com:larryloi/das.git
```
Also Check out STA or HST archiver repo in parent directory
```
git clone git@github.com:larryloi/hst.git
```

**Ensure the proper das version in Dockerfile**

Run the below script to start up docker env
```
bash ./scripts/start-docker-env.sh
```


## How to use this image
When deployed to any container environments, make sure the below environment variables are defined.
```
IMAGE=pfm-hst
TAG=1.0.0
#REPO_PATH=docker-repos:8123/

RECIPIENT='larry.loi@pm.me'
SMTP=hq-prd-mta-vapp01.laxino.local
SMTP_PORT=25
ENV=test1
CHECK_MINS=15
MIGRATION_BASE=db/migrations

SRC_MYSQL_USER=chronos
SRC_MYSQL_PASSWORD=chronos
SRC_MYSQL_HOST=cashplatform_hst_test_host
SRC_MYSQL_PORT=3306
SRC_MYSQL_DATABASE=cashplatform_hst_test
SRC_SCHEMA_TABLE=schema_migrations
SRC_ENABLE_SQL_LOG=false

DST_MYSQL_USER=chronos
DST_MYSQL_PASSWORD=chronos
DST_MYSQL_HOST=cashplatform_hst_test_host
DST_MYSQL_PORT=3306
DST_MYSQL_DATABASE=cashplatform_hst_test
DST_SCHEMA_TABLE=schema_migrations
DST_ENABLE_SQL_LOG=false

#TESTING=1
BATCHES_DEFAULT=2
BATCH_SIZE_DEFAULT=200
BATCHES_BETTING_RECORD=4
BATCH_SIZE_BETTING_RECORD=500
BATCHES_WALLET_RECORD=4
BATCH_SIZE_WALLET_RECORD=500

RTT_OPS_BETTING_RECORD=14d
RTT_OPS_WALLET_RECORD=14d

RTT_OPS_CHRONOS_ARCHIVE_TRANSACTIONS=1000d
RTT_OPS_CHRONOS_TRACE_LOGS=3d

RTT_HST_CHRONOS_ARCHIVE_TRANSACTION_LOGS=1000d
RTT_HST_CHRONOS_TRACE_LOGS=3d
```
