FROM tomcat:11.0-jdk21

COPY RailwayDeploy/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
