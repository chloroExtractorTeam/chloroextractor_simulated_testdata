FROM ubuntu:xenial

RUN apt update && apt install pbzip2 wget bzip2

ADD generate_dataset.sh /tmp
