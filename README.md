# Postfix SMTP to Gmail Relay

A lightweight, containerized Postfix SMTP relay. It accepts unauthenticated emails on port 25 from trusted local networks and securely forwards them to a specific Gmail address using Google SMTP and an App Password.

Perfect for routing alerts from local network devices (like Mikrotik routers, Shelly relays, or homelab services) to a single Gmail inbox.

## Local Deployment (Docker Compose)
1. Edit `stack.env` and provide your Google App Password.
2. Run `docker-compose up -d`.

## Kubernetes Deployment (k3s)
1. Edit the `Secret` in `deployment.yml` with your App Password.
2. Apply the manifest: `kubectl apply -f deployment.yml`.
3. Point your IoT devices to the `postfix-smtp-service` IP on port 25.
