# ==============================================================================
# Base Stage: Using Fedora 43
# ==============================================================================
FROM registry.fedoraproject.org/fedora:43

LABEL maintainer="AI Developer" \
      description="OGX (Open GenAI Stack) Server running on macOS via Podman" \
      version="1.4"

# Set environment variables to optimize Python/Pip behavior inside the container
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    HOME=/home/ogxuser

# 1. Install system dependencies (Runs as root)
RUN dnf update -y && dnf install -y \
    python3 \
    python3-pip \
    git \
    shadow-utils \
    && dnf clean all

# 2. Install 'uv' using pip to guarantee it is in the system PATH
RUN pip install --break-system-packages uv

# 3. Create the non-root user and set up their home directory
RUN useradd -m -s /bin/bash ogxuser
WORKDIR /home/ogxuser

# 4. Install OGX system-wide using uv
RUN uv pip install --system "ogx[starter]"

# FIX: Change ownership of the home directory (and any uv cache files created) to ogxuser
RUN chown -R ogxuser:ogxuser /home/ogxuser

# 5. Switch to the non-root user for runtime security compliance
USER ogxuser

# Expose the default OGX API server port
EXPOSE 8321

# Initialize and start the OGX starter stack
CMD ["uv", "run", "ogx", "stack", "run", "starter"]
