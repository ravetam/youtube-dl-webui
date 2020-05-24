FROM python:3.6-slim

ENV FFMPEG_URL  https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz

RUN apt-get update && apt-get install -y --no-install-recommends wget xz-utils \
    && mkdir -p /tmp/ffmpeg \
    && cd /tmp/ffmpeg \
    && wget -O ffmpeg.tar.xz "$FFMPEG_URL" \
    && tar -xf ffmpeg.tar.xz -C . --strip-components 1 \
    && cp ffmpeg ffprobe qt-faststart /usr/bin \
    && cd .. \
    && rm -fr /tmp/ffmpeg \
    && apt-get purge -y --auto-remove wget xz-utils \
    && rm -fr /var/lib/apt/lists/*

ENV YOUTUBE_DL_WEBUI_SOURCE /usr/src/youtube_dl_webui
WORKDIR $YOUTUBE_DL_WEBUI_SOURCE

RUN pip install --no-cache-dir youtube-dl flask

COPY ./ $YOUTUBE_DL_WEBUI_SOURCE/
COPY default_config.json /etc/youtube-dl-webui.json

EXPOSE 5000

CMD ["python", "-m", "youtube_dl_webui", "-c", "/etc/youtube-dl-webui.json"]
