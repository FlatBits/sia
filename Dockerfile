FROM ubuntu:20.04

ENV PATH /opt/sia/bin:$PATH
ENV SIA_MODULES gctwhr
ENV SIA_DATA_DIR /opt/sia/data
ENV SIAD_DATA_DIR /opt/sia/siad-data
ENV MOUNT_FILE /var/mount/fstab

EXPOSE 9982
EXPOSE 9983

COPY sia /opt/sia
COPY scripts /scripts

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends cifs-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sia

ENTRYPOINT ["/scripts/init.sh"]
