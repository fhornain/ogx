# OGX on Fedora 44

```bash
podman build -t fedora43-ogx:latest .
```

```bash
podman run -d \
  --name ogx-server \
  -p 127.0.0.1:8321:8321 \
  fedora43-ogx:latest
```

```bash
  curl http://127.0.0.1:8321/v1/models
```

```bash
ogx stack run ./config.yaml
```

```bash
version: '2'
distro_name: "local"  # <--- CRITICAL FIX: Tells OGX this is a local user-defined setup

providers:
  inference:
    - provider_id: "ramalama-backend"
      provider_type: "remote::openai"  # Tells OGX to look for an external OpenAI API
      config:
        base_url: "http://localhost:64303/v1"
        api_key: "fake-key"

models:
  - identifier: "ibm-granite/granite-4.0-micro-GGUF"
    provider_id: "ramalama-backend"
```
