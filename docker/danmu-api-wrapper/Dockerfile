ARG BASE_IMAGE=logvar/danmu-api:latest
FROM ${BASE_IMAGE}

ARG BASE_IMAGE
ARG BASE_DIGEST=""
ARG WRAPPER_REVISION=""
ARG WRAPPER_SHA=""

LABEL org.opencontainers.image.title="danmu-api-port-wrapper" \
      org.opencontainers.image.source="https://github.com/huangxd-/danmu_api" \
      org.opencontainers.image.base.name="${BASE_IMAGE}" \
      org.opencontainers.image.base.digest="${BASE_DIGEST}" \
      org.opencontainers.image.revision="${WRAPPER_REVISION}" \
      com.helloagents.wrapper.sha="${WRAPPER_SHA}"

COPY patch_server_port.js /tmp/patch_server_port.js
RUN node /tmp/patch_server_port.js \
  && grep -q "mainServer.listen(9000" /app/danmu_api/server.js \
  && ! grep -q "mainServer.listen(9321" /app/danmu_api/server.js \
  && rm -f /tmp/patch_server_port.js

# 上游镜像 EXPOSE 为 9321；包装层将默认主服务监听端口改为 9000。
EXPOSE 9000
