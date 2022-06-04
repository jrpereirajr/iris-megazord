ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=containers.intersystems.com/intersystems/iris:2021.1.0.215.0
ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

USER root   
## add git
RUN apt update && apt-get -y install git

WORKDIR /home/irisowner/irisbuild

ARG MODULE=iris-megazord
ARG TESTS=1

RUN --mount=type=bind,src=.,dst=. \
    mkdir -p /tmp/test/in && mkdir -p /tmp/test/out && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
