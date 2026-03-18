# Frontend Instrumentation (Go)

- OTel SDK configured with service.name, service.version, deployment.environment
- Auto-instrumentation for HTTP/gRPC
- Custom spans: e.g., template rendering, gRPC client calls
- Custom attributes: user.id, order.total
- Custom metric: e.g., page render count
- OTLP exporter to local agent
