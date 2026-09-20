FROM alpine:3.22

RUN apk add --no-cache ffmpeg

COPY scripts/extract.sh /usr/local/bin/extract-audio
RUN chmod +x /usr/local/bin/extract-audio

WORKDIR /work
ENTRYPOINT ["extract-audio"]
