############################
# Final container
############################
FROM registry.cto.ai/official_images/bash:2-buster-slim

WORKDIR /ops

RUN apt-get --quiet update && \
  apt-get -y --quiet install jq && \
  curl -o tugboat.tar.gz https://dashboard.tugboat.qa/cli/linux/tugboat.tar.gz && \
  tar -zxf tugboat.tar.gz -C /usr/local/bin/ && \
  rm tugboat.tar.gz && \
  apt-get clean

ADD . .
