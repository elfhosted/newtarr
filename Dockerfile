FROM python:3.13-slim

WORKDIR /app

# net-tools is used by health checks
RUN apt-get update && apt-get install -y --no-install-recommends net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

# Unraid's default nobody:users (99:100); the app never needs root
RUN mkdir -p /config/settings /config/stateful /config/user /config/logs \
    && chown -R 99:100 /config /app
USER 99:100

ENV PYTHONPATH=/app
EXPOSE 9705
CMD ["python3", "main.py"]
