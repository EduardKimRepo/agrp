# Agent Governance Response Protocol (AGRP) v0.3

## Status

Draft RFC-style specification.

## 1. Abstract

AGRP defines a machine-readable governance response protocol for autonomous and semi-autonomous software agents. AGRP is transport-agnostic and is designed to operate alongside HTTP, RPC, workflow engines, and message buses. It standardizes governance outcomes such as identity requirements, payment authorization, policy violation, scope mismatch, human approval, delegation restrictions, remediation workflows, incident creation, rerouting, certification expiry, trust insufficiency, and execution freezes.

AGRP does **not** replace business APIs. It adds a deterministic governance layer above application transport so agent consumers can make safe execution decisions under institutional, legal, and operational constraints.

## 2. Conventions and Terminology

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** in this document are to be interpreted as normative requirements.

### 2.1 Core Terms

- **Issuer**: governance authority or enforcement point emitting an AGRP response.
- **Consumer**: agent, orchestrator, gateway, or execution environment receiving an AGRP response.
- **Primary Code**: the single AGRP code representing the authoritative governance outcome for a decision point.
- **Strict Core Profile**: minimum interoperable AGRP response shape with no undefined top-level fields.
- **Extension Namespace**: namespaced object carrying vendor-, domain-, or deployment-specific metadata without redefining core semantics.
- **Conformance Level**: deployment capability tier indicating how completely AGRP is implemented.

## 3. Design Goals

AGRP aims to provide:

- deterministic governance semantics for agent systems
- compatibility with existing transport protocols
- portable remediation and escalation behavior
- human-in-the-loop control points
- support for signatures and auditability
- extensibility without semantic drift
- conformance profiles suitable for regulated deployments

## 4. Protocol Model

A single application decision can yield both:

- a **transport result** such as HTTP 403, gRPC permission denied, or workflow error, and
- an **AGRP governance result** such as `603 capability_missing`.

The transport layer indicates whether the request succeeded at the application boundary. AGRP explains the governance meaning of that outcome.

### 4.1 Primary Envelope

Every AGRP response MUST contain:

- `agrp_version`
- `agrp_code`
- `reason`
- `issuer`
- `timestamp`

Every AGRP response SHOULD contain:

- `correlation_id`
- `http_status` or equivalent transport reference when applicable

An AGRP response MAY contain:

- code-specific remediation fields
- cryptographic signature material
- policy references
- incident or ticket references
- extension namespaces under `extensions`

### 4.2 Single-Code Rule

An issuer MUST emit exactly one **primary** `agrp_code` for each governance decision point.

If multiple governance conditions apply, the issuer MUST choose the code with the most immediate execution consequence according to the following precedence:

1. `615 execution_frozen`
2. `610 remediation_required`
3. `605 human_approval_required`
4. `604 policy_violation`
5. `613 certification_expired`
6. `614 trust_level_insufficient`
7. `601 identity_required`
8. `607 scope_mismatch`
9. `608 intent_conflict`
10. `609 delegation_not_allowed`
11. `603 capability_missing`
12. `602 payment_required`
13. `606 governance_rate_limit`
14. `611 incident_ticket_created`
15. `612 rerouted_to_specialist_agent`

Secondary conditions MAY be included in `extensions` or referenced incident records, but MUST NOT redefine the primary outcome.

## 5. Strict Core Profile

The **Strict Core Profile** is the baseline interoperable profile. It exists to prevent AGRP from becoming a loose JSON convention.

### 5.1 Required Fields

A Strict Core AGRP object MUST contain exactly these top-level fields unless otherwise stated:

- `agrp_version` (string, exact value for this spec: `"0.3"`)
- `agrp_code` (integer)
- `reason` (string)
- `issuer` (string)
- `timestamp` (RFC 3339 date-time string)
- `correlation_id` (string)

It MAY also contain:

- `http_status` (integer)
- `details` (object)
- `signature` (object)
- `extensions` (object)

No other top-level fields are permitted in the Strict Core Profile.

### 5.2 `details` Object

All code-specific fields MUST be placed inside `details`. This prevents uncontrolled top-level growth.

Examples:

- `details.required_capability`
- `details.approval_role`
- `details.policy_reference`
- `details.ticket_id`

### 5.3 Core Validation Rules

Strict Core consumers MUST reject or quarantine responses when:

- `agrp_code` and `reason` do not match the registry
- required fields are absent
- unknown top-level fields are present
- signature profile is declared but validation fails
- code-specific required `details` members are missing

### 5.4 Core Interoperability Promise

A deployment claiming Strict Core conformance MUST be able to parse, validate, and act on all standard AGRP codes `601` through `615` without relying on vendor extensions.

## 6. Extension Namespace Model

AGRP allows deployment-specific metadata only through the `extensions` object.

### 6.1 Namespace Rules

`extensions` MUST be an object whose immediate children are namespace keys.

Namespace keys MUST follow one of these patterns:

- reverse-DNS style, for example `eu.registack`
- URI-style authority keys, for example `https://registack.eu/ns/finance`

Example:

```json
{
  "extensions": {
    "eu.registack": {
      "tenant_id": "tenant-alpha",
      "decision_hash": "sha256:..."
    },
    "https://registack.eu/ns/finance": {
      "cost_center": "CC-104",
      "reservation_id": "RES-9f2a"
    }
  }
}
```

### 6.2 Extension Constraints

Extensions MUST NOT:

- redefine standard code meanings
- contradict core fields
- introduce alternative top-level code identifiers
- change the meaning of `reason`
- replace required core fields

Extensions MAY:

- add domain-specific remediation metadata
- add workflow references
- add policy evidence hashes
- add vendor-specific attestation data
- add localized explanatory text

### 6.3 Extension Processing

Consumers MUST ignore unknown extension namespaces unless deployment policy requires namespace-specific handling.

Consumers MUST preserve unknown extensions when forwarding AGRP objects, unless explicit data minimization policy forbids it.

### 6.4 Namespace Ownership

Deployments SHOULD only emit namespaces they control. Public ecosystems SHOULD publish extension namespace documentation and versioning policy.

## 7. Code Registry

### 7.1 Registry Rules

The AGRP registry is the authoritative mapping between numeric codes and symbolic reasons.

A standard code registration MUST define:

- numeric code
- symbolic reason
- short description
- execution class
- required `details` fields
- recommended transport mappings
- consumer handling guidance
- security considerations

Standard meanings for codes `601` to `615` are immutable once published, except for editorial clarifications.

### 7.2 Standard Registry Table

| Code | Reason | Description | Execution Class |
|---|---|---|---|
| 601 | `identity_required` | Agent identity verification required | block-remediate |
| 602 | `payment_required` | Budget or payment authorization required | block-remediate |
| 603 | `capability_missing` | Required capability not present | block-remediate |
| 604 | `policy_violation` | Action violates governance policy | block-stop |
| 605 | `human_approval_required` | Human authorization required | block-await-human |
| 606 | `governance_rate_limit` | Governance threshold exceeded | retry-later |
| 607 | `scope_mismatch` | Action outside agent scope | block-remediate |
| 608 | `intent_conflict` | Declared and inferred intent conflict | block-review |
| 609 | `delegation_not_allowed` | Task delegation prohibited | block-remediate |
| 610 | `remediation_required` | Incident remediation required | block-remediate |
| 611 | `incident_ticket_created` | Incident ticket generated | informational-escalate |
| 612 | `rerouted_to_specialist_agent` | Task reassigned to another agent | continue-rerouted |
| 613 | `certification_expired` | Agent certification expired | block-remediate |
| 614 | `trust_level_insufficient` | Agent trust level insufficient | block-remediate |
| 615 | `execution_frozen` | Execution suspended by governance controls | emergency-stop |

### 7.3 Required `details` Members by Code

| Code | Required `details` Members |
|---|---|
| 601 | `identity_provider`, `required_identity_assurance` |
| 602 | `budget_id`, `required_amount`, `payment_authority` |
| 603 | `required_capability` |
| 604 | `policy_reference` |
| 605 | `approval_role` |
| 606 | `limit_scope`, `retry_after_seconds`, `threshold_type` |
| 607 | `declared_scope`, `requested_scope` |
| 608 | `declared_intent`, `inferred_intent` |
| 609 | `delegation_target`, `delegation_policy` |
| 610 | `remediation_actions` |
| 611 | `ticket_id` |
| 612 | `specialist_agent_id`, `specialist_capability` |
| 613 | `certificate_id`, `expired_at`, `required_certification` |
| 614 | `required_trust_level`, `actual_trust_level` |
| 615 | `freeze_reason`, `freeze_reference` |

## 8. Header and Body Transport Bindings

AGRP is transport-agnostic. This section defines standard bindings.

### 8.1 HTTP Header Binding

When AGRP is bound to HTTP headers, producers SHOULD emit:

- `AGRP-Version`
- `AGRP-Code`
- `AGRP-Reason`
- `AGRP-Issuer`
- `AGRP-Timestamp`
- `AGRP-Correlation-Id`

If a signed profile is used, producers SHOULD emit:

- `AGRP-Signature-Alg`
- `AGRP-Signature-KeyId`
- `AGRP-Signature`

Code-specific `details` SHOULD NOT be fragmented into many headers unless the body is unavailable. If needed, they MAY be exposed through a single compact header such as:

- `AGRP-Details: base64url(<canonical-json>)`

Example:

```text
HTTP/1.1 403 Forbidden
AGRP-Version: 0.3
AGRP-Code: 603
AGRP-Reason: capability_missing
AGRP-Issuer: registack.eu
AGRP-Timestamp: 2026-03-16T12:00:00Z
AGRP-Correlation-Id: corr-9b20ac7f
Content-Type: application/agrp+json
```

### 8.2 HTTP Body Binding

For JSON bodies, the media type SHOULD be:

- `application/agrp+json`

Example:

```json
{
  "agrp_version": "0.3",
  "agrp_code": 603,
  "reason": "capability_missing",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T12:00:00Z",
  "correlation_id": "corr-9b20ac7f",
  "http_status": 403,
  "details": {
    "required_capability": "financial_transaction"
  }
}
```

### 8.3 gRPC Binding

For gRPC, AGRP core fields SHOULD be transported in trailing metadata using lower-case keys:

- `agrp-version`
- `agrp-code`
- `agrp-reason`
- `agrp-issuer`
- `agrp-timestamp`
- `agrp-correlation-id`

`details` SHOULD be encoded as canonical JSON and carried in:

- `agrp-details-bin`

### 8.4 Event Bus Binding

For Kafka, NATS, SQS, or workflow events, AGRP SHOULD be embedded as a dedicated envelope field:

```json
{
  "event_type": "task.rejected",
  "agrp": { ...strict-core-object... },
  "payload": { ...domain-event... }
}
```

## 9. Consumer State Machine

Consumers MUST implement deterministic handling behavior. The minimum processing state machine is:

1. **Receive**
2. **Parse**
3. **Validate Core**
4. **Verify Signature** if present or required
5. **Match Registry Entry**
6. **Classify Execution Class**
7. **Transition to Action State**
8. **Persist Audit Record**
9. **Emit Local Outcome**

### 9.1 Action States

| Execution Class | Required Consumer Action |
|---|---|
| `block-remediate` | stop current action, surface remediation path |
| `block-stop` | stop permanently for this request instance |
| `block-await-human` | suspend until authorized human decision arrives |
| `retry-later` | schedule retry using provided delay or policy backoff |
| `block-review` | stop and request review workflow |
| `informational-escalate` | create or attach incident/ticket context |
| `continue-rerouted` | continue against specialist destination |
| `emergency-stop` | freeze local execution branch and prevent further side effects |

### 9.2 Code-to-State Mapping

- `601`, `602`, `603`, `607`, `609`, `610`, `613`, `614` -> `block-remediate`
- `604` -> `block-stop`
- `605` -> `block-await-human`
- `606` -> `retry-later`
- `608` -> `block-review`
- `611` -> `informational-escalate`
- `612` -> `continue-rerouted`
- `615` -> `emergency-stop`

### 9.3 Retry Rules

Consumers MUST NOT blindly retry for codes:

- `604`
- `607`
- `608`
- `609`
- `610`
- `613`
- `614`
- `615`

Consumers MAY retry `606` only after the provided delay or policy-computed backoff.

Consumers MAY retry `601`, `602`, `603`, and `605` only after the missing prerequisite has been satisfied.

### 9.4 Reroute Rules

For `612`, consumers MUST preserve:

- original `correlation_id`
- prior incident references if any
- relevant policy context

Consumers SHOULD mark the original route as superseded rather than failed.

## 10. Signed Response Profile

Signed AGRP responses provide issuer authenticity, integrity, and replay resistance.

### 10.1 Signature Object

When present, `signature` MUST be an object with:

- `profile`
- `alg`
- `kid`
- `value`

It MAY contain:

- `nonce`
- `created`
- `expires`
- `canonicalization`
- `cert_chain_ref`

Example:

```json
"signature": {
  "profile": "agrp-jws-detached-0.3",
  "alg": "EdDSA",
  "kid": "key-2026-q1",
  "created": "2026-03-16T12:00:00Z",
  "expires": "2026-03-16T12:05:00Z",
  "nonce": "n-7f3a",
  "canonicalization": "JCS",
  "value": "<detached-signature>"
}
```

### 10.2 Canonicalization

The signed payload MUST be the canonical JSON representation of the AGRP object excluding `signature.value`.

The canonicalization method for this profile is:

- `JCS` for JSON canonicalization

### 10.3 Verification Rules

Consumers in signed-profile deployments MUST:

- verify the signature before acting on high-risk codes
- validate `kid` against trusted issuer metadata
- reject expired signatures
- reject duplicate nonce values within the replay window
- bind signature verification to `issuer`

### 10.4 Minimum Signed-Profile Coverage

Deployments claiming signed AGRP support MUST sign at least responses for:

- `604 policy_violation`
- `605 human_approval_required`
- `610 remediation_required`
- `611 incident_ticket_created`
- `613 certification_expired`
- `615 execution_frozen`

## 11. Conformance Levels per Deployment

Conformance is declared at the deployment level, not just the schema level.

### 11.1 Level A — Observe

A Level A deployment MUST:

- emit valid Strict Core AGRP objects
- support all standard codes for parseability
- preserve `correlation_id`
- log AGRP decisions

A Level A deployment MAY omit signatures and automated remediation.

### 11.2 Level B — Enforce

A Level B deployment MUST satisfy Level A and also:

- implement deterministic state-machine handling
- enforce code-specific required `details`
- support `606` retry handling
- support `605` human approval suspension
- support `612` rerouting behavior

### 11.3 Level C — Assure

A Level C deployment MUST satisfy Level B and also:

- implement the Signed Response Profile
- maintain replay protection
- preserve audit records for all AGRP outcomes
- verify issuer trust anchors
- support incident linkage for `610`, `611`, and `615`

### 11.4 Level D — Institutional

A Level D deployment MUST satisfy Level C and also:

- publish its supported extension namespaces
- publish conformance statement and policy references
- support certification and trust enforcement for `613` and `614`
- support governance freeze propagation for `615`
- provide operator-facing audit export and traceability

### 11.5 Deployment Statement

A conformant deployment SHOULD publish a machine-readable statement such as:

```json
{
  "agrp_version": "0.3",
  "conformance_level": "C",
  "supported_codes": [601,602,603,604,605,606,607,608,609,610,611,612,613,614,615],
  "signed_profile": "agrp-jws-detached-0.3",
  "extension_namespaces": ["eu.registack"],
  "issuer": "registack.eu"
}
```

## 12. Security Considerations

Implementations SHOULD:

- validate issuer trust anchors
- enforce clock skew tolerance and signature expiry
- protect incident identifiers from unauthorized disclosure
- rate-limit malformed AGRP envelopes
- prevent extension-based semantic shadowing
- isolate untrusted extension processing

## 13. Privacy Considerations

AGRP details MAY contain sensitive operational, policy, financial, or incident data. Producers SHOULD minimize detail fields to what the receiving actor needs. Event-bus deployments SHOULD separate sensitive details from broadly distributed payloads.

## 14. IANA-Style Registry Stewardship

A future AGRP registry authority SHOULD manage:

- standard code allocations
- reserved ranges
- deprecated registrations
- extension namespace recommendations
- conformance profile identifiers
- signed-profile identifiers

Suggested ranges:

- `601–649`: standard governance codes
- `650–679`: provisional or experimental consortium codes
- `680–699`: private deployment codes

Private codes MUST NOT reuse standard symbolic reasons.

## 15. Example Strict Core Response

```json
{
  "agrp_version": "0.3",
  "agrp_code": 615,
  "reason": "execution_frozen",
  "issuer": "registack.eu",
  "timestamp": "2026-03-16T12:00:00Z",
  "correlation_id": "corr-9b20ac7f",
  "http_status": 423,
  "details": {
    "freeze_reason": "anomalous_payment_pattern_detected",
    "freeze_reference": "FRZ-2026-0041",
    "incident_reference": "INC-2026-00314"
  },
  "signature": {
    "profile": "agrp-jws-detached-0.3",
    "alg": "EdDSA",
    "kid": "key-2026-q1",
    "created": "2026-03-16T12:00:00Z",
    "expires": "2026-03-16T12:05:00Z",
    "nonce": "n-7f3a",
    "canonicalization": "JCS",
    "value": "<detached-signature>"
  },
  "extensions": {
    "eu.registack": {
      "tenant_id": "tenant-alpha",
      "case_priority": "critical"
    }
  }
}
```

## 16. Relationship to Prior Drafts

Compared with earlier AGRP drafts, this version introduces:

- a strict top-level profile
- a dedicated extension namespace model
- deployment conformance levels
- registry immutability and precedence rules
- transport bindings
- a normative consumer state machine
- a signed response profile

