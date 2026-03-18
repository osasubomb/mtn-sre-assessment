# MTN SRE Assessment

This repository contains the implementation for the MTN Nigeria SRE Practical Assessment (Elastic Stack + OpenTelemetry).

## Structure
- `otel-collector/`: Helm values and configs for OpenTelemetry Collector (agent/gateway, sampling policy)
- `instrumentation/`: Service instrumentation code/patches (Go, .NET, Node.js)
- `rum/`: Browser RUM agent integration
- `dashboards/`: Kibana dashboards (NDJSON exports)
- `infrastructure/`: Agent/Beat configs, alert rules, integrations

## Quick Start
1. Provision GCP infra (GKE, Cloud SQL, Memorystore) using Terraform (see `infrastructure/`).
2. Deploy Elastic Stack (Elastic Cloud free tier or self-hosted on GKE).
3. Deploy Online Boutique app and NGINX Ingress.
4. Deploy OTel Collector (agent/gateway) using Helm and provided values.
5. Instrument services (see `instrumentation/`).
6. Integrate RUM agent in frontend (see `rum/`).
7. Import Kibana dashboards from `dashboards/`.
8. Configure alerting rules in Kibana (see `infrastructure/alerting-rules/`).
