# ==============================================================================
# Base Stage: Using Fedora 44
# ==============================================================================
FROM --platform=linux/aarch64 registry.fedoraproject.org/fedora:44

LABEL maintainer="AI Developer" \
      description="OGX (Open GenAI Stack) Server on Fedora 44" \
      version="1.0"

# Set environment variables to optimize Python/Pip behavior inside the container
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    UV_COMPILE_BYTECODE=1 \
    HOME=/home/ogxuser

# Install system dependencies needed for Python, UV, and OGX tools
RUN dnf update -y && dnf install -y \
    python3 \
    python3-pip \
    curl \
    git \
    shadow-utils \
    && dnf clean all

# Create a non-root user for security compliance
RUN useradd -m -s /bin/bash ogxuser

# Switch to the non-root user
USER ogxuser
WORKDIR /home/ogxuser

# Install 'uv' (modern fast Python package installer) into the user's local path
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/ogxuser/.local/bin:${PATH}"

# FIX: Changed '--user' to '--system'. 
# This tells uv to bypass virtualenv checks since we are safe inside a container.
RUN uv pip install --system "ogx[starter]"

# Expose the default OGX API server port
EXPOSE 8321

# Initialize and start the OGX starter stack
# This environment sets up an OpenAI-compatible endpoint locally
CMD ["uv", "run", "ogx", "stack", "run", "starter"]
