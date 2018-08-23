
FROM jboss/wildfly
RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent
ADD ./execute.sh /usr/local/wildfly/config/
ADD ./commands.cli /usr/local/wildfly/config/
ADD ./wildflyconfig.properties /usr/local/wildfly/config/
ADD ./jdbc /usr/local/wildfly/config/jdbc
ADD ./serverconfig/standalone-custom.xml /usr/local/wildfly/config/
ADD ./serverconfig/application-roles.properties /usr/local/wildfly/config/
ADD ./serverconfig/application-users.properties /usr/local/wildfly/config/
ADD ./serverconfig/logging.properties /usr/local/wildfly/config/
ADD ./serverconfig/mgmt-groups.properties /usr/local/wildfly/config/
ADD ./serverconfig/mgmt-users.properties /usr/local/wildfly/config/
COPY ./serverconfig/init_container.sh /bin/init_container.sh

USER root
RUN chmod +x /usr/local/wildfly/config/execute.sh
RUN chmod +x /bin/init_container.sh
#USER jboss
#add system vvariables
#ENV JAVA_OPTS $JAVA_OPTS-Dsite.server.base.dir=/usr/local/wildfly
# execute customizations - adding the postgres driver and datasource
RUN /usr/local/wildfly/config/execute.sh
# copy the applicationPetstore.war file from host to standalone deployment
# COPY ./deployments/applicationPetstore.war /usr/local/wildfly/deployments/
#COPY ./deployments/applicationPetstore.war /opt/jboss/wildfly/standalone/deployments
#cleanup
RUN rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history
#automatically launch the standalone configuration
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone.xml"] 
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-custom.xml", "-P", "/usr/local/wildfly/config/wildflyconfig.properties"]
ENTRYPOINT ["/bin/init_container.sh"]