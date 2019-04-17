### Running the container

The InfluxDB image exposes a shared volume under /var/lib/influxdb, so one can mount a host directory to that point to access persisted container data. 
A typical invocation of the container might be:

````bash
$ docker run -p 8086:8086 \
      -v $PWD:/var/lib/influxdb \
      influxdb
````


Modify `$PWD` to the directory where you want to store data associated with the InfluxDB container.

By default during the build following databases creates:
    
    jmeter
    security_tests

as well as following users:
    
    tiger_admin
    puma

All of the above could be replaced with passed values at build-time to the builder with the docker build command using the `--build-arg <varname>=<value>` flag

```bash
$ docker build --build-arg \
                db_name=jmeter \
                admin=tiger_admin \
                techuser=puma \
                second_db=security_tests 
```

If there is no value passed at build-time, the builder uses the default.

### Exposed Ports

The following ports are important and are used by InfluxDB.

    8086 HTTP API port
    8083 Administrator interface port, if it is enabled
    2003 Graphite support, if it is enabled

The HTTP API port will be automatically exposed when using `docker run -P`.

### Configuration

InfluxDB can be either configured from a config file or using environment variables. 
To mount a configuration file and use it with the server, one can use this command:

```bash
$ docker run -p 8086:8086 \
      -v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
      influxdb -config /etc/influxdb/influxdb.conf

```

For environment variables, the format is INFLUXDB_$SECTION_$NAME. 

Examples:

    INFLUXDB_HTTP_AUTH_ENABLED=true
    INFLUXDB_META_DIR=/path/to/metadir
    INFLUXDB_DATA_QUERY_LOG_ENABLED=false
All dashes (-) are replaced with underscores (_).
If the variable isn’t in a section, then omit that part.

```bash
$ docker run -p 8086:8086 \
      -v $PWD:/var/lib/influxdb \
      -e INFLUXDB_HTTP_AUTH_ENABLED=true influxdb
```

#### Database Initialization

The InfluxDB image contains some extra functionality for initializing a database. 
These options are not suggested for production, but are quite useful when running standalone instances for testing.

The database initialization script will only be called when running influxd. 
It will not be executed when running any other program.

#### Environment Variables

The InfluxDB image uses several environment variables to automatically configure certain parts of the server. 
They may significantly aid you in using this image.

##### INFLUXDB_DB

Automatically initializes a database with the name of this environment variable.

##### INFLUXDB_HTTP_AUTH_ENABLED

Enables authentication. 
Either this must be set or `auth-enabled = true` must be set within the configuration file for any authentication related options below to work.

##### INFLUXDB_ADMIN_USER

The name of the admin user to be created.
If this is unset, no admin user is created.

##### INFLUXDB_ADMIN_PASSWORD

The password for the admin user configured with `INFLUXDB_ADMIN_USER`.
If this is unset, a random password is generated and printed to standard out.

##### INFLUXDB_USER

The name of a user to be created with no privileges.
If `INFLUXDB_DB` is set, this user will be granted read and write permissions for that database.

##### INFLUXDB_USER_PASSWORD

The password for the user configured with `INFLUXDB_USER`.
If this is unset, a random password is generated and printed to standard out.

####Initialization Files

If the Docker image finds any files with the extensions `.sh` or `.iql` inside of the `/docker-entrypoint-initdb.d` folder, it will execute them.
The order they are executed in is determined by the shell.
This is usually alphabetical order.
