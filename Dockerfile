FROM ubuntu:xenial

RUN apt update && apt install pbzip2 wget bzip2

ADD generate_dataset.sh /tmp

VOLUME /data
WORKDIR /tmp

CMD /tmp/generate_dataset.sh
