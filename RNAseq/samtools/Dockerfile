# This is a multi-stage build Dockerfile for samtools, bcftools, and htslib

# Stage 1
FROM debian:stretch-slim as tools

ENV HTSLIB_VERSION 1.9
ADD https://github.com/samtools/samtools/releases/download/${HTSLIB_VERSION}/samtools-${HTSLIB_VERSION}.tar.bz2 /tmp/samtools.tar.bz2
ADD https://github.com/samtools/bcftools/releases/download/${HTSLIB_VERSION}/bcftools-${HTSLIB_VERSION}.tar.bz2 /tmp/bcftools.tar.bz2
ADD https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 /tmp/htslib.tar.bz2
RUN apt update && apt -y install \
		g++ make libc-dev curl git wget \
		zlib1g-dev libbz2-dev bzip2 liblzma-dev libncurses-dev \
	&& cd /tmp/ \
	&& mkdir samtools \
	&& tar xjvf samtools.tar.bz2 -C samtools --strip-components=1 \
	&& cd samtools \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /tmp/ \
	&& mkdir bcftools \
	&& tar xjvf bcftools.tar.bz2 -C bcftools --strip-components=1 \
	&& cd bcftools \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /tmp \
	&& mkdir htslib \
	&& tar xjvf htslib.tar.bz2 -C htslib --strip-components=1 \
	&& cd htslib \
	&& ./configure \
	&& make

FROM debian:stretch-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
		findutils \
		perl \
		zlib1g-dev libbz2-dev liblzma-dev libncurses-dev \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

COPY --from=tools /usr/local/bin/samtools /usr/bin
COPY --from=tools /usr/local/bin/bcftools /usr/bin
COPY --from=tools /tmp/htslib/bgzip /usr/bin
COPY --from=tools /tmp/htslib/tabix /usr/bin

CMD ["bash"]
