CURL = curl

all:

deps:

updatenightly:
	$(CURL) -sSLf https://raw.githubusercontent.com/wakaba/ciconfig/master/ciconfig | RUN_GIT=1 REMOVE_UNUSED=1 perl

deps-circleci:
	cp cd-bare stable/
	cp cd-bare chromium/

test-circleci:
	git clone https://github.com/manakai/perl-web-driver-client
	cd perl-web-driver-client && make test-deps

	docker run -d -it quay.io/wakaba/base:stable bash
	ip route | awk '/docker0/ { print $$NF }' > docker0-ip.txt
	cat docker0-ip.txt

	mkdir temp; echo 'FROM quay.io/wakaba/base:stable' > temp/Dockerfile
	echo 'RUN apt-get update && apt-get install -y ffmpeg' >> temp/Dockerfile
	docker build -t temp temp

	docker run --name server1 -d -p 9515:9515 --add-host=dockerhost:`cat docker0-ip.txt` quay.io/wakaba/chromedriver:stable /cd
	docker logs server1 > $$CIRCLE_ARTIFACTS/server1.txt &
	while ! curl -f http://localhost:9515/status ; do sleep 1; done
	cd perl-web-driver-client && TEST_WD_URL=http://localhost:9515 WEBUA_DEBUG=2 TEST_SERVER_LISTEN_HOST=0.0.0.0 TEST_SERVER_HOSTNAME=dockerhost make test
	! docker run -i -t temp timeout 2 ffprobe rtp://224.0.0.56:9515 # or fail

	docker logs server1
	docker kill server1

	docker run --name server2 -d -p 9515:9515 --add-host=dockerhost:`cat docker0-ip.txt` -e WD_RTP_PORT=5553 quay.io/wakaba/chromedriver:chromium /cd
	docker logs server1 > $$CIRCLE_ARTIFACTS/server2.txt &
	while ! curl -f http://localhost:9515/status ; do sleep 1; done
	cd perl-web-driver-client && TEST_WD_URL=http://localhost:9515 WEBUA_DEBUG=2 TEST_SERVER_LISTEN_HOST=0.0.0.0 TEST_SERVER_HOSTNAME=dockerhost make test
	docker run -i -t temp timeout 2 ffprobe rtp://224.0.0.56:5553 # or fail

	docker logs server2
	docker kill server2

## License: Public Domain.
