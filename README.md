 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-megazord)
 [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)

<!--
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-megazord&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-megazord)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-megazord&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-megazord)
-->

## iris-megazord (🏗️ Under construction...)

A lot of ideas together. Different projects, one goal.

Integration of previous tools, like IRIS Monitor, with a wizard for easy development of interoperability flows.

## Videos

![FHIRaaS sample](https://github.com/jrpereirajr/iris-megazord/blob/master/img/chrome_Xs1BYHGxqm.gif?raw=true)

 ![IRIS Megazord Flow](https://github.com/jrpereirajr/iris-megazord/blob/6d41f60d2494c9c1b3c87e4e2dd996cd01c7a203/img/chrome_DcCKlFrEix.gif?raw=true)

[![Flow Editor - IRIS Megazord](https://img.youtube.com/vi/KkG0_-ahfjI/0.jpg)](https://www.youtube.com/watch?v=KkG0_-ahfjI)

If you'd like to try the same process shown in the video, you can follow [this steps](https://github.com/jrpereirajr/iris-chatbot#setting-up-a-telegram-bot) and set a Telegram Bot to use in your test.

## Online demo

You can check the application out [here](https://iris-megazord.demo.community.intersystems.com/csp/irisflow/index.csp).

## Installation prerequisites

If you'd like to test the project in your environment, make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## ZPM installation

```
USER>zpm "install iris-megazord"
```

## Docker installation

If the online demo is not available anymore or you would like to play with the project code, you can set up a docker container. In order to get your container running, follow these steps:

Clone/git pull the repo into any local directory

```
$ git clone git@github.com:jrpereirajr/iris-megazord.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```

## Unit tests

In order to execute the unit tests, run the following command in the shell terminal:

```bash
iris session iris "##class(%ZPM.PackageManager).Shell(\"test iris-megazord -v\",1,1)"
```


## Dream team

* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
* [Henry Pereira](https://community.intersystems.com/user/henry-pereira)
