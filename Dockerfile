FROM tomcat:8
ADD ./gameoflife.war /usr/local/tomcat/webapps/webapp.war
EXPOSE 8080
MAINTAINER "satish"          