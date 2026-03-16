# Agent Governance Response Protocol (AGRP) v0.1

## Status

Draft specification.

## Abstract

AGRP defines a machine-readable governance response layer for autonomous software agents. It augments existing HTTP and RPC responses with structured governance semantics that allow agents to resolve authorization, policy, payment, capability, and human oversight requirements.

## Design Goals

- Machine-readable governance signals
- Compatibility with existing HTTP semantics
- Clear remediation paths for agents
- Human-in-the-loop support
- Extensible code range and payload schema

## Core Model

AGRP operates in parallel with transport-layer responses.

Example:

- Transport status: `HTTP 403`
- Governance status: `AGRP 603`

## Initial AGRP Codes

| Code | Symbol | Meaning |
|---|---|---|
| 601 | `identity_required` | Verified agent identity is required |
| 602 | `payment_required` | Payment or budget approval is required |
| 603 | `capability_missing` | Required capability or clearance is missing |
| 604 | `policy_violation` | Request violates a governing policy |
| 605 | `human_approval_required` | A human decision is required before execution |
| 606 | `governance_rate_limit` | Governance limits or operational quotas are exceeded |
| 607 | scope_mismatch | Action outside agent scope |
| 608 | intent_conflict | Declared and inferred intent conflict |
| 609 | delegation_not_allowed | Task delegation prohibited |
| 610 | remediation_required | Incident remediation required |
| 611 | incident_ticket_created | Incident ticket generated |
| 612 | rerouted_to_specialist_agent | Task reassigned to another agent |
| 613 | certification_expired | Agent certification expired |
| 614 | trust_level_insufficient | Agent trust level insufficient |
| 615 | execution_frozen | Execution suspended by governance controls |

## Example

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

## Transport Options

- HTTP headers
- JSON response body
- gRPC metadata
- event envelopes in message buses

## Security Considerations

Implementations should support:

- signed governance responses
- issuer validation
- tamper-evident policy references
- auditable timestamps

## Open Questions

- registry and stewardship model
- conflict resolution between transport and AGRP responses
- remediation workflows
- standardization path
