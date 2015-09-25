
run: build jenkins-volume docker-volume
	docker rm jenkins-master || true
	docker run -d -p 8080:8080 --name=jenkins-master \
		--volumes-from jenkins-volume \
		--volumes-from docker-volume \
   			docs-jenkins
	sleep 6
	docker exec -t jenkins-master tar -C /var/jenkins_home/jobs/ -xvf /var/jenkins_home/leeroy.tar
	# Can't use the jenkins-cli unless I know the user/pass/token
	# java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ safe-restart

leeroy: build-leeroy
	docker run --rm -it -p 80:80 --link jenkins-master \
		docs-leeroy -d

build: build-jenkins build-docker build-leeroy

logs:
	docker logs -f jenkins-master

shell:
	docker exec -it jenkins-master bash

stop:
	docker stop jenkins-master

clean:
	docker rm -vf jenkins-master || true

realclean: clean
	docker rm -vf jenkins-volume || true
	docker rmi -f docs-jenkins

# persist the config
jenkins-volume:
	docker inspect jenkins-volume > /dev/null \
		|| docker run -v /var/jenkins_home \
			--user=jenkins \
			--entrypoint=true \
			--name=jenkins-volume docs-jenkins

docker-volume: build-docker
	# I'd love to share a static docker client from here too, but you can't make volume files
	docker inspect docker-volume > /dev/null \
		|| docker run --name docker-volume \
			-v /var/run/docker.sock:/var/run/docker.sock \
			docker-client version

build-jenkins:
	docker build -t docs-jenkins jenkins/

build-docker:
	docker build -t docker-client docker/

build-leeroy:
	docker build -t docs-leeroy leeroy/
