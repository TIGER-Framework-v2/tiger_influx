FROM influxdb:1.8-alpine

ENV HOME_DIR=/home/influx

RUN addgroup -g 1000 -S 1000 && \
    adduser -S -G 1000 -u 1000 -s /bin/bash -h /home/influx influx

USER influx

ARG db_name=jmeter
ARG admin=tiger_admin
ARG techuser=puma
ARG second_db=security_tests
ARG auth=true

ENV INFLUXDB_DB=${db_name} INFLUXDB_ADMIN_USER=${admin} INFLUXDB_USER=${techuser} SECOND_DB=${second_db} INFLUXDB_HTTP_AUTH_ENABLED=${auth} INFLUXDB_META_DIR=${HOME_DIR}/meta INFLUXDB_DATA_DIR=${HOME_DIR}/data INFLUXDB_DATA_WAL_DIR=${HOME_DIR}/wal

COPY influxdb.sh /docker-entrypoint-initdb.d/influxdb.sh
EXPOSE 8086
