ARG BASE_IMAGE=joeanamier/tiktok-downloader:latest
FROM ${BASE_IMAGE}

ARG BASE_IMAGE
ARG BASE_DIGEST=""
ARG WRAPPER_REVISION=""
ARG WRAPPER_SHA=""

LABEL org.opencontainers.image.title="tiktok-downloader-webapi-wrapper" \
      org.opencontainers.image.source="https://github.com/JoeanAmier/TikTokDownloader" \
      org.opencontainers.image.base.name="${BASE_IMAGE}" \
      org.opencontainers.image.base.digest="${BASE_DIGEST}" \
      org.opencontainers.image.revision="${WRAPPER_REVISION}" \
      com.helloagents.wrapper.sha="${WRAPPER_SHA}"

RUN sed -i 's/SERVER_HOST = "127.0.0.1"/SERVER_HOST = "0.0.0.0"/' /app/src/custom/static.py \
  && grep -q 'SERVER_HOST = "0.0.0.0"' /app/src/custom/static.py

COPY entrypoint.sh /usr/local/bin/tiktok-downloader-webapi-entrypoint
RUN chmod +x /usr/local/bin/tiktok-downloader-webapi-entrypoint

ENTRYPOINT ["/usr/local/bin/tiktok-downloader-webapi-entrypoint"]
CMD ["python", "main.py"]
