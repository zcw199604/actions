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

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    chromium \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir playwright

RUN sed -i 's/SERVER_HOST = "127.0.0.1"/SERVER_HOST = "0.0.0.0"/' /app/src/custom/static.py \
  && grep -q 'SERVER_HOST = "0.0.0.0"' /app/src/custom/static.py

# Patch upstream FastAPI app to add a single-page pagination endpoint for Douyin account works.
# We do this in the wrapper layer so we can keep tracking upstream image updates.
# Important: do not rely on Dockerfile heredoc/BuildKit here. Some build environments (or local
# dev machines) may not have buildx enabled; in that case the heredoc can silently turn into a
# no-op and the endpoint will be missing.
COPY patch_main_server.py /tmp/patch_main_server.py
RUN python /tmp/patch_main_server.py \
  && grep -q "/douyin/account/page" /app/src/application/main_server.py \
  && rm -f /tmp/patch_main_server.py

COPY entrypoint.sh /usr/local/bin/tiktok-downloader-webapi-entrypoint
RUN chmod +x /usr/local/bin/tiktok-downloader-webapi-entrypoint

ENTRYPOINT ["/usr/local/bin/tiktok-downloader-webapi-entrypoint"]
CMD ["python", "main.py"]
