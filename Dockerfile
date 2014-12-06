FROM ubuntu:14.04
ADD . /code
WORKDIR /code
RUN apt-get update && apt-get -y dist-upgrade 
RUN apt-get -y install make python-pip
RUN make deps
