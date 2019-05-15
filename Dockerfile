FROM influxdb:alpine

ARG db_name=jmeter
ARG admin=tiger_admin
ARG techuser=puma
ARG second_db=security_tests
ARG auth=true

ENV INFLUXDB_DB=${db_name} INFLUXDB_ADMIN_USER=${admin} INFLUXDB_USER=${techuser} SECOND_DB=${second_db} INFLUXDB_HTTP_AUTH_ENABLED=${auth}

COPY influxdb.sh /docker-entrypoint-initdb.d/influxdb.sh
EXPOSE 8086