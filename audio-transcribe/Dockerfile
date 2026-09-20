FROM alpine:3.22

RUN apk add --no-cache \
    ffmpeg \
    python3 \
    py3-cffi \
    py3-vosk-api=0.3.50-r1 \
    vosk-api=0.3.50-r1 \
    unzip

RUN wget -q https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip -O /tmp/model.zip \
    && unzip -q /tmp/model.zip -d /models \
    && mv /models/vosk-model-small-en-us-0.15 /models/en-us \
    && rm /tmp/model.zip

COPY scripts/transcribe.py /usr/local/bin/audio-transcribe
RUN chmod +x /usr/local/bin/audio-transcribe

WORKDIR /work
ENTRYPOINT ["python3", "/usr/local/bin/audio-transcribe"]
