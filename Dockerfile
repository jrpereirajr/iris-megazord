ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
ARG IMAGE=containers.intersystems.com/intersystems/iris:2021.1.0.215.0
ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

ARG SYSTEM_PWD="SYS"
ARG TELEGRAM_APIKEY
ARG CLIMATIQ_APIKEY

USER root   
## add git
RUN apt update && apt-get -y install git

WORKDIR /home/irisowner/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /home/irisowner/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

ARG MODULE=iris-megazord
ARG TESTS=0

COPY src src
COPY iris.script iris.script
COPY module.xml module.xml
COPY misc/ContestRole.xml ContestRole.xml

RUN mkdir -p /tmp/test/in && mkdir -p /tmp/test/out && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris session iris "##class(dc.irisflow.util.Setup).ChangePassword(\"_system\",\"$SYSTEM_PWD\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).ChangePassword(\"CSPSystem\",\"$SYSTEM_PWD\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).ChangePassword(\"Admin\",\"$SYSTEM_PWD\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).ChangePassword(\"_Ensemble\",\"$SYSTEM_PWD\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).ChangePassword(\"irisowner\",\"$SYSTEM_PWD\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).DisabledUser(\"SuperUser\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).DisabledUser(\"UnknownUser\")" && \
    iris session iris "##class(dc.irisflow.util.Setup).DisabledUser(\"IAM\")" && \
    iris session iris "##class(Ens.Config.Credentials).SetCredential(\"telegram-api-key\",\"\",\"$TELEGRAM_APIKEY\")" && \
    iris session iris "##class(Ens.Config.Credentials).SetCredential(\"climatiq-api-key\",\"\",\"$CLIMATIQ_APIKEY\")" && \
    iris session iris "##class(dc.irisflow.demo.ClimatiqAPIExample01).Create()" && \
    iris session iris "##class(dc.irisflow.demo.ClimatiqAPIExample02).Create()" && \
    iris session iris "##class(dc.irisflow.util.Setup).AutoStartProduction(\"User.ClimatiqAPIExample02\",0)" && \
    iris session iris "##class(dc.irisflow.util.Setup).CreateContestUser()" && \
    iris stop IRIS quietly
