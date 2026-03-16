# Agent Governance Response Protocol (AGRP) v0.1

AGRP is a proposed machine-readable governance response layer for autonomous AI agents.

It is designed to run **in parallel with HTTP status codes**, enabling APIs and digital infrastructure to communicate governance requirements such as identity, payment, capability, policy, and human approval constraints to autonomous agents.

## Why AGRP

Traditional HTTP responses were designed for human-operated applications.

Autonomous agents need structured governance signals to determine what to do next when an action is blocked or constrained.

Example:

- `HTTP 403 Forbidden`
- `AGRP 603 capability_missing`

Payload:

```json
{
  "agrp_code": 603,
  "reason": "capability_missing",
  "required_capability": "financial_transaction",
  "required_clearance": "level_3",
  "issuer": "registack.eu"
}
```

## Initial Code Range

| Code | Name | Description |
|---|---|---|
| 601 | identity_required | The agent must provide a verified identity |
| 602 | payment_required | Payment or budget authorization required |
| 603 | capability_missing | The agent lacks the required capability |
| 604 | policy_violation | The request violates a defined policy |
| 605 | human_approval_required | The action requires human authorization |
| 606 | governance_rate_limit | Governance limits exceeded |
| 607 | scope_mismatch | Action outside agent scope |
| 608 | intent_conflict | Declared and inferred intent conflict |
| 609 | delegation_not_allowed | Task delegation prohibited |
| 610 | remediation_required | Incident remediation required |
| 611 | incident_ticket_created | Incident ticket generated |
| 612 | rerouted_to_specialist_agent | Task reassigned to another agent |
| 613 | certification_expired | Agent certification expired |
| 614 | trust_level_insufficient | Agent trust level insufficient |
| 615 | execution_frozen | Execution suspended by governance controls |

## Repository Layout

- `spec/` — protocol drafts and normative text
- `schemas/` — JSON schema definitions
- `examples/` — response examples
- `docs/` — additional technical notes

## Suggested Next Steps

1. Publish as a public draft repository.
2. Add an RFC-style draft under `spec/`.
3. Add reference implementations for HTTP and gRPC.
4. Define signing, issuer trust, and remediation semantics.
5. Start a working group around the draft.

## Suggested GitHub Repo Name

- `agrp`
- `agent-governance-response-protocol`
- `agrp-spec`

## License

This scaffold includes an MIT license placeholder. Replace it if you want a different licensing model.
