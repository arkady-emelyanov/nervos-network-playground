FROM ubuntu:focal

RUN apt-get -qq -y update \
    && apt-get install -qq -y curl bash openssl tini

RUN cd /tmp \
    && curl -LO https://github.com/nervosnetwork/ckb-cli/releases/download/v0.100.0/ckb-cli_v0.100.0_x86_64-unknown-linux-gnu.tar.gz \
    && tar xvfz ckb-cli_v0.100.0_x86_64-unknown-linux-gnu.tar.gz \
    && mv ckb-cli_v0.100.0_x86_64-unknown-linux-gnu/ckb-cli /usr/local/bin/ \
    && chmod +x /usr/local/bin/ckb-cli \
    && chown root:root /usr/local/bin/ckb-cli \
    && rm -rf ckb-cli_v0.100.0_x86_64-unknown-linux-gnu*

RUN cd /tmp \
    && curl -LO https://github.com/nervosnetwork/ckb/releases/download/v0.100.0/ckb_v0.100.0_x86_64-unknown-linux-gnu.tar.gz \
    && tar xvfz ckb_v0.100.0_x86_64-unknown-linux-gnu.tar.gz \
    && mv ckb_v0.100.0_x86_64-unknown-linux-gnu/ckb /usr/local/bin/ \
    && chmod +x /usr/local/bin/ckb \
    && chown root:root /usr/local/bin/ckb \
    && rm -rf ckb_v0.100.0_x86_64-unknown-linux-gnu*

RUN useradd -m -s /bin/bash ckb \
    && mkdir -p /data \
    && chown ckb:ckb /data \
    && mkdir -p /config \
    && chown ckb:ckb /config

COPY blockchain/scripts/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh \
    && chown root:root /usr/local/bin/*.sh

VOLUME ["/data"]
VOLUME ["/config"]

WORKDIR /home/ckb
USER ckb
ENTRYPOINT ["tini", "-g", "--"]
