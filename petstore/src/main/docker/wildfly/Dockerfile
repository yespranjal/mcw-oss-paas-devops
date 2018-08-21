
FROM jboss/wildfly
RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent
ADD ./execute.sh /opt/config/
ADD ./commands.cli /opt/config/
ADD ./jdbc /opt/jdbc/
USER root
RUN chmod +x /opt/config/execute.sh
USER jboss
# execute customizations - adding the postgres driver and datasource
RUN /opt/config/execute.sh
# copy the applicationPetstore.war file from host to standalone deployment
COPY ./deployments/applicationPetstore.war /opt/jboss/wildfly/standalone/deployments
#cleanup
RUN rm -rf $JBOSS_HOME/standalone/configuration/standalone_xml_history
#automatically launch the standalone configuration
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone.xml"]