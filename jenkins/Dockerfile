FROM jenkins
MAINTAINER Sven Dowideit <SvenDowideit@docker.com>

VOLUME /var/jenkins_home
USER root

ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300"

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /usr/bin/docker
RUN chmod 755 /usr/bin/docker
COPY setup-docker-and-start-jenkins.sh /
ENTRYPOINT ["/setup-docker-and-start-jenkins.sh"]

# Stay as root so we can addthe docker group as needed
