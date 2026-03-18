# AGRP — Agent Governance Response Protocol
**Version:** v0.4 (Draft)  
**Status:** Draft  
**Author:** Eduard Kim  
**License:** Apache-2.0  

---

# 1. Abstract

The **Agent Governance Response Protocol (AGRP)** defines a standardized machine-readable protocol for signaling governance decisions, runtime events, and enforcement outcomes in AI agent execution environments.

AGRP enables infrastructure systems to communicate deterministic governance signals related to:

- agent identity verification
- capability authorization
- scope enforcement
- trust evaluation
- lifecycle governance
- runtime execution control
- remediation workflows

The protocol is designed for use in:

- AI agent gateways
- agent orchestration platforms
- enterprise AI governance infrastructure
- regulated automation systems
- agent-to-agent execution environments

AGRP responses provide structured governance signals that can be processed automatically by agents, gateways, orchestration platforms, and compliance systems.

---

# 2. Design Goals

AGRP is designed to provide:

- deterministic governance signaling
- machine-readable enforcement decisions
- interoperability across agent ecosystems
- auditability and compliance readiness
- extensibility for institutional environments
- compatibility with runtime execution environments
- support for lifecycle governance

---

# 3. Protocol Model

AGRP defines governance signals across the **entire agent execution lifecycle**, from detection to remediation.

The protocol uses numeric code ranges to represent different governance phases.

| Range | Category |
|------|---------|
| 100–199 | Detection / Observation |
| 200–299 | Identity Verification |
| 300–399 | Policy Evaluation |
| 400–499 | Governance Decision |
| 500–599 | Execution Control |
| 600–699 | Governance Response |
| 700–799 | Remediation |

---

# 4. Response Envelope

An AGRP response **MUST** be returned as a JSON object.

Example:

```json
{
  "agrp_version": "0.4",
  "agrp_code": 607,
  "reason": "scope_mismatch",
  "message": "Requested action outside agent scope",
  "timestamp": "2026-03-17T12:15:30Z",
  "agent_id": "agent-9283",
  "details": {
    "requested_scope": "database.delete",
    "allowed_scope": [
      "database.read",
      "database.update"
    ]
  }
}


