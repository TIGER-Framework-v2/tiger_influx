FROM influxdb:alpine

ARG db_name=jmeter
ARG admin=tiger_admin
ARG techuser=puma
ARG techuserpass

ENV INFLUXDB_DB=${db_name} INFLUXDB_ADMIN_USER=${admin} INFLUXDB_USER=${techuser} INFLUXDB_USER_PASSWORD=${techuserpass}

ADD influxdb.conf /etc/influxdb/influxdb.conf
EXPOSE 8086