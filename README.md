podman build -t fedora43-ogx:latest .
podman run -d \
  --name ogx-server \
  -p 127.0.0.1:8321:8321 \
  fedora43-ogx:latest
  curl http://127.0.0.1:8321/v1/models
