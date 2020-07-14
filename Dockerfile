# build siasync
FROM ubuntu:20.04 AS builder

ARG GO_VERSION=1.14.4

RUN echo "Installing apt dependencies" && apt-get update && apt-get install -y curl git build-essential sudo python3-pip && pip3 install codespell

RUN echo "Installing golang ${GO_VERSION}" && curl -sSL https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | tar -C /usr/local -xz

ENV PATH=$PATH:/usr/local/go/bin

RUN echo "Clone Sia Repo" && git clone https://gitlab.com/NebulousLabs/Sia.git /app

WORKDIR /app

RUN echo "Applying patch" && git fetch --all --tags && git checkout 'v1.4.11' && \
git config --global user.name "Maxime Belanger" && git config --global user.email 'mbelanger@flatbits.com' && \
git cherry-pick -X theirs 4b8206d2 && \
git cherry-pick -X theirs e0400e0a && \
git cherry-pick -X theirs 5f2c4401

RUN echo "Build Sia" && make dependencies && make

FROM ubuntu:20.04

ENV PATH /opt/sia/bin:$PATH
ENV SIA_MODULES gctwhr
ENV SIA_DATA_DIR /opt/sia/data
ENV SIAD_DATA_DIR /opt/sia/siad-data

EXPOSE 9980 9982 9983

COPY --from=builder /root/go/bin/siac /opt/sia/bin/siac
COPY --from=builder /root/go/bin/siad /opt/sia/bin/siad
COPY scripts /scripts

WORKDIR /opt/sia

ENTRYPOINT ["/scripts/init.sh"]
