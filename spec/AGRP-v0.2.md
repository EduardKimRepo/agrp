# Agent Governance Response Protocol (AGRP) v0.2

## Status

Draft specification.

## Abstract

AGRP defines a machine-readable governance response layer for autonomous software agents. It augments transport-layer responses such as HTTP, RPC, and event-bus acknowledgements with structured governance semantics that let agents and execution environments determine whether a requested action may proceed, must be remediated, requires human approval, must be rerouted, or has been frozen by policy.

AGRP is designed for institutional and regulated agent systems in which identity, scope, payment authority, certification, trust level, escalation, and auditability must be enforced consistently across heterogeneous execution environments.

## Design Goals

- Machine-readable governance semantics for agents
- Compatibility with existing HTTP, RPC, and event-driven systems
- Deterministic remediation and escalation paths
- Human-in-the-loop support where required
- Support for certification, trust, and scope enforcement
- Extensible code ranges and payload schema
- Auditability, signatures, and issuer accountability

## Core Model

AGRP operates in parallel with transport-layer responses.

Example:

- Transport status: `HTTP 403`
- Governance status: `AGRP 603 capability_missing`

A transport status answers whether the request succeeded at the transport or application boundary. An AGRP response explains the governance state that caused the decision.

## Response Envelope

An AGRP response SHOULD contain:

- `agrp_code`: numeric governance code
- `reason`: symbolic code name
- `issuer`: governance issuer, registry, or enforcement layer
- `timestamp`: RFC 3339 timestamp

An AGRP response MAY contain:

- transport metadata such as `http_status`
- remediation hints
- payment, approval, scope, trust, or certification data
- incident and ticket references
- rerouting instructions
- cryptographic signature and policy references

## AGRP Governance Code Registry

| Code | Symbol | Description |
|---|---|---|
| 601 | `identity_required` | Agent identity verification required |
| 602 | `payment_required` | Budget or payment authorization required |
| 603 | `capability_missing` | Required capability not present |
| 604 | `policy_violation` | Action violates governance policy |
| 605 | `human_approval_required` | Human authorization required |
| 606 | `governance_rate_limit` | Governance threshold exceeded |
| 607 | `scope_mismatch` | Action outside agent scope |
| 608 | `intent_conflict` | Declared and inferred intent conflict |
| 609 | `delegation_not_allowed` | Task delegation prohibited |
| 610 | `remediation_required` | Incident remediation required |
| 611 | `incident_ticket_created` | Incident ticket generated |
| 612 | `rerouted_to_specialist_agent` | Task reassigned to another agent |
| 613 | `certification_expired` | Agent certification expired |
| 614 | `trust_level_insufficient` | Agent trust level insufficient |
| 615 | `execution_frozen` | Execution suspended by governance controls |

## Normative Semantics by Code

### 601 `identity_required`
The requester is not sufficiently identified, bound, or attested for the requested action.

Typical remediation:
- present a verifiable agent identity
- bind the agent to a tenant, operator, or execution environment
- repeat the request with identity proof

### 602 `payment_required`
The action requires budget reservation, payment approval, spending policy confirmation, or settlement authorization before execution.

Typical remediation:
- attach budget approval or payment token
- obtain spending authorization from a policy authority or human approver

### 603 `capability_missing`
The requester lacks a required capability, clearance, permission class, or operational module.

Typical remediation:
- obtain the missing capability
- escalate to a higher-clearance agent
- reroute to an agent with the declared capability

### 604 `policy_violation`
The requested action conflicts with an applicable governance, legal, compliance, safety, or organizational policy.

Typical remediation:
- modify the action to comply with the referenced policy
- seek a policy exception where permitted

### 605 `human_approval_required`
The action may proceed only after an authorized human decision.

Typical remediation:
- route to the specified approval role
- attach approval evidence and resubmit

### 606 `governance_rate_limit`
The action exceeds a governance threshold, quota, concurrency cap, velocity limit, or intervention threshold.

Typical remediation:
- back off and retry after the specified interval
- request quota elevation

### 607 `scope_mismatch`
The action is outside the requesting agent's declared or allowed scope.

Typical remediation:
- narrow the action to the registered scope
- use another agent whose scope matches the task

### 608 `intent_conflict`
The declared intent and the inferred or observed intent do not match, creating a governance conflict.

Typical remediation:
- resubmit with a corrected declared intent
- request human review when the conflict is material

### 609 `delegation_not_allowed`
The task may not be delegated further due to policy, trust, confidentiality, or execution constraints.

Typical remediation:
- execute directly if permitted
- request explicit delegation approval

### 610 `remediation_required`
Execution may not continue until a remediation workflow has been completed.

Typical remediation:
- complete the listed remediation actions
- submit evidence of remediation closure

### 611 `incident_ticket_created`
A governance or execution incident ticket was created as part of handling the request or failure.

Typical remediation:
- reference the ticket in subsequent retries or escalations
- complete required follow-up steps

### 612 `rerouted_to_specialist_agent`
The request was not rejected outright but reassigned to another agent better suited or authorized to perform the task.

Typical remediation:
- continue the workflow with the designated specialist agent
- preserve correlation IDs and execution context

### 613 `certification_expired`
The agent's certification, attestation, or approval status has expired for the requested class of work.

Typical remediation:
- renew certification
- use a currently certified agent

### 614 `trust_level_insufficient`
The agent's trust tier is below the minimum required for the requested action, dataset, or environment.

Typical remediation:
- elevate trust through attestation or policy review
- reroute to a higher-trust agent

### 615 `execution_frozen`
Governance controls have suspended execution due to investigation, risk containment, policy intervention, or emergency stop conditions.

Typical remediation:
- await unfreeze or override by authorized governance personnel
- inspect referenced incident and freeze context

## Response Examples

### 601 identity_required
```json
{
  "http_status": 401,
  "agrp_code": 601,
  "reason": "identity_required",
  "identity_provider": "registack.eu/identity",
  "required_identity_assurance": "loa_2",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:00:00Z"
}
```

### 602 payment_required
```json
{
  "http_status": 402,
  "agrp_code": 602,
  "reason": "payment_required",
  "budget_id": "BUD-2026-00482",
  "required_amount": {
    "currency": "EUR",
    "value": "250.00"
  },
  "payment_authority": "org-finance-policy",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:01:00Z"
}
```

### 603 capability_missing
```json
{
  "http_status": 403,
  "agrp_code": 603,
  "reason": "capability_missing",
  "required_capability": "financial_transaction",
  "required_clearance": "level_3",
  "issuer": "registack.eu",
  "timestamp": "2026-03-15T12:00:00Z"
}
```

### 604 policy_violation
```json
{
  "http_status": 403,
  "agrp_code": 604,
  "reason": "policy_violation",
  "policy_reference": "POL-DATA-004",
  "policy_clause": "cross_border_transfer_without_basis",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:02:00Z"
}
```

### 605 human_approval_required
```json
{
  "http_status": 403,
  "agrp_code": 605,
  "reason": "human_approval_required",
  "approval_role": "organization_admin",
  "risk_level": "high",
  "issuer": "registack.eu",
  "timestamp": "2026-03-15T12:00:00Z"
}
```

### 606 governance_rate_limit
```json
{
  "http_status": 429,
  "agrp_code": 606,
  "reason": "governance_rate_limit",
  "limit_scope": "tenant:alpha/procurement",
  "retry_after_seconds": 300,
  "threshold_type": "high_risk_actions_per_hour",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:03:00Z"
}
```

### 607 scope_mismatch
```json
{
  "http_status": 403,
  "agrp_code": 607,
  "reason": "scope_mismatch",
  "declared_scope": "invoice_review",
  "requested_scope": "vendor_payment_execution",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:04:00Z"
}
```

### 608 intent_conflict
```json
{
  "http_status": 409,
  "agrp_code": 608,
  "reason": "intent_conflict",
  "declared_intent": "summarize_invoice",
  "inferred_intent": "modify_payment_terms",
  "confidence": 0.93,
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:05:00Z"
}
```

### 609 delegation_not_allowed
```json
{
  "http_status": 403,
  "agrp_code": 609,
  "reason": "delegation_not_allowed",
  "delegation_target": "external_settlement_agent",
  "delegation_policy": "POL-DELEGATION-002",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:06:00Z"
}
```

### 610 remediation_required
```json
{
  "http_status": 409,
  "agrp_code": 610,
  "reason": "remediation_required",
  "remediation_actions": [
    "rotate_agent_credentials",
    "revalidate_policy_bindings"
  ],
  "incident_reference": "INC-2026-00314",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:07:00Z"
}
```

### 611 incident_ticket_created
```json
{
  "http_status": 202,
  "agrp_code": 611,
  "reason": "incident_ticket_created",
  "ticket_id": "TCK-2026-1042",
  "incident_reference": "INC-2026-00314",
  "ticket_queue": "governance-ops",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:08:00Z"
}
```

### 612 rerouted_to_specialist_agent
```json
{
  "http_status": 307,
  "agrp_code": 612,
  "reason": "rerouted_to_specialist_agent",
  "specialist_agent_id": "agent://registack.eu/agents/payment-specialist-7",
  "specialist_capability": "vendor_payment_execution",
  "correlation_id": "corr-9b20ac7f",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:09:00Z"
}
```

### 613 certification_expired
```json
{
  "http_status": 403,
  "agrp_code": 613,
  "reason": "certification_expired",
  "certificate_id": "CERT-AGENT-9921",
  "expired_at": "2026-03-01T00:00:00Z",
  "required_certification": "financial_controls_v2",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:10:00Z"
}
```

### 614 trust_level_insufficient
```json
{
  "http_status": 403,
  "agrp_code": 614,
  "reason": "trust_level_insufficient",
  "required_trust_level": "tier_4",
  "actual_trust_level": "tier_2",
  "trust_policy": "TRUST-POL-009",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:11:00Z"
}
```

### 615 execution_frozen
```json
{
  "http_status": 423,
  "agrp_code": 615,
  "reason": "execution_frozen",
  "freeze_reason": "anomalous_payment_pattern_detected",
  "freeze_reference": "FRZ-2026-0041",
  "incident_reference": "INC-2026-00314",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T09:12:00Z"
}
```

## Transport Options

AGRP MAY be transported via:

- HTTP headers
- JSON response bodies
- gRPC metadata
- event envelopes in message buses
- workflow orchestration events

Example HTTP headers:

```text
X-AGRP-Code: 603
X-AGRP-Reason: capability_missing
X-AGRP-Issuer: registack.eu
```

## Processing Rules

### Producer behavior
An AGRP issuer SHOULD:

- emit exactly one primary `agrp_code` per decision point
- include `reason` matching the registered symbolic name
- include `issuer` and `timestamp`
- include remediation metadata where available
- sign the response where trust boundaries require non-repudiation

### Consumer behavior
An AGRP consumer SHOULD:

- evaluate `agrp_code` independently of transport status
- branch to remediation, approval, rerouting, or retry logic based on code semantics
- persist incident, reroute, and freeze references for audit and replay-safe recovery
- avoid blind retries for codes 604, 607, 608, 609, 610, 613, 614, and 615

## Security Considerations

Implementations SHOULD support:

- signed governance responses
- issuer validation
- tamper-evident policy references
- auditable timestamps
- correlation and replay protection
- confidentiality controls for incident metadata

## IANA-Style Registry Considerations

The AGRP code registry SHOULD be stewarded under a public or consortium governance process. Vendor-specific extensions MAY use subranges or namespaced extension objects, but registered meanings for standard codes 601-615 MUST NOT be redefined.

## Open Questions

- public registry and stewardship model
- conflict resolution when transport and AGRP semantics differ materially
- standard remediation workflow contracts
- mapping to common workflow engines and message buses
- conformance test suite and certification profile
