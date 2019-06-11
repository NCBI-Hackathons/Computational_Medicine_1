FROM debian:stretch-slim

ENV ASELUX_VER 1.0.1
ADD https://github.com/abl0719/ASElux/archive/${ASELUX_VER}.tar.gz /tmp/aselux.tar.gz

RUN apt update && apt -y install g++ make libc-dev
RUN cd /tmp \
        && mkdir aselux \
	&& tar xzvf aselux.tar.gz -C aselux --strip-components=1 \
	&& cd aselux \
	&& make \
        && mv bin/ASElux /usr/bin \
        && cd .. \
        && rm -Rf *

CMD ["bash"]

