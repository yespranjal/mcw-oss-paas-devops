#!/bin/bash

JBOSS_HOME=/opt/jboss/wildfly

JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh

# It doesn't contains support for messaging,Jacorb, CMP (java EE web profile)

#JBOSS_PROFILE=standalone.xml

# It contains support like messaging,Jacorb, CMP (java EE full EE stack profile)

JBOSS_PROFILE=standalone.xml

function wait_for_server() {   until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do

        sleep 1

  done

  }

echo "=> Starting WildFly server"

$JBOSS_HOME/bin/standalone.sh -c $JBOSS_PROFILE > /dev/null &



echo "=> Waiting for the server to boot"

wait_for_server

echo "==> setting environment variables"
#sed "s/<resolve-parameter-values>false<\/resolve-parameter-values>/<resolve-parameter-values>true<\/resolve-parameter-values>/" $JBOSS_HOME/bin/jboss-cli.xml
export POSTGRES_USERNAME="postgres"
export POSTGRES_PASSWORD="example"
export POSTGRES_CONNECTIONURL="jdbc:postgresql://db:5432/postgres"
printenv >> $JBOSS_HOME/appSettings.properties

# Add postgres module
echo "=> Adding driver module"
$JBOSS_CLI -c --file=/opt/config/commands.cli --properties=$JBOSS_HOME/appSettings.properties
echo $POSTGRES_USERNAME
$JBOSS_CLI -c ":shutdown"
# Add postgres driver - this is already done in the Dockerfile

# Add postgres driver
#echo "=> Adding driver"
#$JBOSS_CLI --connect "/subsystem=datasources/jdbc-driver=postgres:add(driver-name=postgres,driver-module-name=org.postgres,driver-class-name=org.postgresql.Driver,driver-xa-datasource-class-name=org.postgresql.xa.PGXADataSource) "

# Add the datasource
#echo "=> Adding data source"
#$JBOSS_CLI --connect "data-source add --name=PostgresDS --driver-name=postgres --jndi-name=java:jboss/datasources/PostgresDS --connection-url=jdbc:postgresql://postgresdb:5432/postgres --user-name=postgres --password=example --use-ccm=true --max-pool-size=5 --blocking-timeout-wait-millis=5000 --enabled=true --driver-class=org.postgresql.Driver --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter --jta=true --use-java-context=true --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker"
#echo "=> Done Adding data source"