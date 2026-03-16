# AGRP — Agent Governance Response Protocol
Version: v0.3 (Draft)

Status: Draft  
Author: Eduard Kim
License: Apache-2.0

---

## 1. Abstract

The Agent Governance Response Protocol (AGRP) defines a standardized machine-readable response format for governance decisions in agent execution environments.

AGRP enables infrastructure systems to communicate enforcement decisions regarding identity, scope, trust, certification, and policy compliance for AI agents.

The protocol is designed for use in:

- agent-to-agent execution environments
- AI orchestration systems
- enterprise governance layers
- regulated automation infrastructure

AGRP responses provide deterministic governance signals that can be processed by agents, gateways, and orchestration platforms.

---

## 2. Design Goals

AGRP is designed to provide:

- deterministic governance signaling
- machine-readable enforcement responses
- interoperability across agent ecosystems
- auditability and compliance readiness
- extensibility for institutional environments

---

## 3. Response Envelope

An AGRP response MUST be returned as a JSON object.

Example:

```json
{
  "agrp_version": "0.3",
  "agrp_code": 607,
  "reason": "scope_mismatch",
  "message": "Requested action outside agent scope",
  "timestamp": "2026-03-16T10:15:30Z",
  "agent_id": "agent-9283",
  "details": {
    "requested_scope": "database.delete",
    "allowed_scope": ["database.read", "database.update"]
  }
}
