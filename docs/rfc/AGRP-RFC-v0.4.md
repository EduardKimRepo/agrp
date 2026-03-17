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

# 5. Core Response Fields

| Field | Type | Description |
|------|------|-------------|
| agrp_version | string | AGRP protocol version |
| agrp_code | integer | Governance response code |
| reason | string | Machine-readable reason identifier |
| message | string | Human-readable explanation |
| timestamp | string | ISO-8601 timestamp |
| agent_id | string | Calling agent identifier |
| correlation_id | string | Execution correlation identifier |
| issuer | string | Governance authority issuing the response |
| details | object | Optional code-specific data |

---

# 6. Governance Code System

AGRP codes are grouped by governance phase to reflect the lifecycle of an AI agent execution event.

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

## 6.1 Detection Codes (100–199)

Observation of agent presence or runtime activity.

| Code | Name | Description |
|-----|------|-------------|
| 101 | agent_detected | Agent detected in environment |
| 102 | agent_identity_observed | Identity fingerprint captured |
| 103 | capability_inventory_detected | Agent capabilities discovered |
| 104 | scope_inventory_detected | Agent scopes discovered |
| 105 | runtime_environment_detected | Runtime environment detected |
| 106 | identity_fingerprint_created | Identity hash generated |
| 107 | agent_registration_candidate | Discovery candidate identified |
| 108 | runtime_instance_detected | Agent runtime instance detected |
| 109 | agent_execution_attempt | Execution attempt detected |
| 110 | runtime_identity_presented | Runtime identity presented |

---

## 6.2 Identity Verification Codes (200–299)

Identity validation and binding evaluation.

| Code | Name | Description |
|-----|------|-------------|
| 201 | identity_verified | Identity verified successfully |
| 202 | identity_unverified | Identity verification failed |
| 203 | identity_mismatch | Identity hash mismatch detected |
| 204 | identity_missing | Runtime identity missing |
| 205 | identity_drift_detected | Identity drift detected |
| 206 | identity_binding_valid | Identity binding verified |
| 207 | identity_binding_invalid | Identity binding failure |
| 208 | identity_recertification_required | Identity requires recertification |

---

## 6.3 Policy Evaluation Codes (300–399)

Governance policy evaluation phase.

| Code | Name | Description |
|-----|------|-------------|
| 301 | policy_evaluation_started | Policy evaluation initiated |
| 302 | policy_evaluation_passed | Policies satisfied |
| 303 | policy_evaluation_failed | Policy violation detected |
| 304 | policy_scope_violation | Scope violation |
| 305 | policy_capability_violation | Capability violation |
| 306 | policy_trust_level_violation | Trust level insufficient |
| 307 | policy_certification_violation | Certification invalid |
| 308 | policy_rate_limit_triggered | Governance rate limit exceeded |

---

## 6.4 Governance Decision Codes (400–499)

Final governance decisions regarding execution.

| Code | Name | Description |
|-----|------|-------------|
| 401 | execution_allowed | Execution permitted |
| 402 | execution_conditionally_allowed | Execution allowed with warning |
| 403 | execution_denied | Execution denied |
| 404 | execution_requires_human | Human approval required |
| 405 | execution_rerouted | Task rerouted to another agent |

---

## 6.5 Execution Control Codes (500–599)

Execution lifecycle signals.

| Code | Name | Description |
|-----|------|-------------|
| 501 | execution_started | Execution started |
| 502 | execution_in_progress | Execution ongoing |
| 503 | execution_completed | Execution completed |
| 504 | execution_aborted | Execution aborted |
| 505 | execution_suspended | Execution temporarily suspended |
| 506 | execution_resumed | Execution resumed |
| 507 | execution_terminated | Execution terminated |

---

## 6.6 Governance Response Codes (600–699)

Governance enforcement responses.

| Code | Name | Description |
|-----|------|-------------|
| 601 | identity_required | Verified identity required |
| 602 | payment_required | Payment authorization required |
| 603 | capability_missing | Required capability missing |
| 604 | policy_violation | Request violates governance policy |
| 605 | human_approval_required | Human authorization required |
| 606 | governance_rate_limit | Governance rate limit exceeded |
| 607 | scope_mismatch | Action outside agent scope |
| 608 | intent_conflict | Declared and inferred intent conflict |
| 609 | delegation_not_allowed | Task delegation prohibited |
| 610 | remediation_required | Incident remediation required |
| 611 | incident_ticket_created | Incident ticket created |
| 612 | rerouted_to_specialist_agent | Task reassigned to specialist agent |
| 613 | certification_expired | Agent certification expired |
| 614 | trust_level_insufficient | Agent trust level insufficient |
| 615 | execution_frozen | Execution suspended by governance |

---

## 6.7 Remediation Codes (700–799)

Governance remediation processes.

| Code | Name | Description |
|-----|------|-------------|
| 701 | remediation_started | Remediation process started |
| 702 | remediation_in_progress | Remediation ongoing |
| 703 | remediation_completed | Remediation completed |
| 704 | remediation_failed | Remediation failed |
| 705 | remediation_recertification | Agent requires recertification |
| 706 | remediation_identity_reset | Identity reset required |
| 707 | remediation_policy_update | Governance policy update required |

---

# 7. Execution Model

AGRP responses are generated by governance infrastructure including:

- agent gateways
- governance engines
- compliance controllers
- orchestration platforms

The response signals whether execution may:

- proceed
- pause
- be denied
- be rerouted
- require remediation

---

# 8. Security Considerations

AGRP responses may be cryptographically signed to ensure authenticity and prevent tampering.

Recommended mechanisms include:

- JWS signatures
- platform identity attestations
- secure transport via TLS

Future AGRP versions may introduce signed response profiles.

---

# 9. Relationship to Registack

AGRP serves as the **governance signaling layer** within the **Registack institutional AI infrastructure**.

Registack provides:

- agent identity registration
- lifecycle certification management
- runtime governance enforcement
- execution environment control

AGRP provides the **machine-readable response protocol** used by these governance systems.

---

# 10. Future Work

Future versions of AGRP may introduce:

- signed governance responses
- deterministic governance state machines
- distributed agent trust registries
- cross-agent remediation protocols
- governance event streaming
- policy evaluation profiles

---