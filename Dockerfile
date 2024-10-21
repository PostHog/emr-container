FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --no-cache-dir boto3

RUN if [ "$(uname -m)" = "x86_64" ]; then \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$(uname -m)" = "aarch64" ]; then \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    else \
    echo "Unsupported architecture"; \
    exit 1; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

CMD ["bash", "-c", "source /opt/venv/bin/activate && exec bash"]
