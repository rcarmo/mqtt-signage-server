FROM ubuntu:14.04
ADD . /code
WORKDIR /code
RUN make deps
