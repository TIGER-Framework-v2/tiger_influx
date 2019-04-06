FROM influxdb:alpine

ARG db_name=jmeter
ARG admin=tiger_admin
ARG techuser=puma
ARG techuserpass
ARG second_db=security_tests

ENV INFLUXDB_DB=${db_name} INFLUXDB_ADMIN_USER=${admin} INFLUXDB_USER=${techuser} INFLUXDB_USER_PASSWORD=${techuserpass} SECOND_DB=${second_db}

ADD influxdb.conf /etc/influxdb/influxdb.conf
COPY influxdb.sh /docker-entrypoint-initdb.d/influxdb.sh
EXPOSE 8086