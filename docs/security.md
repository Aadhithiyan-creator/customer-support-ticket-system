# Security

- Use a sandbox for initial deployment and testing.
- Grant `Support_Ticket_Agent` only to staff approved for ticket assignment; assignment eligibility is based on permission set membership.
- The permission set does not grant delete, view-all, or modify-all rights. It exposes the classifier service and selected ticket fields.
- Review sharing, field-level security, customer data retention, and profiles in the target org. The custom object uses `ReadWrite` sharing in this project so collaborators can work tickets; production orgs should review whether private ownership or criteria-based sharing is more appropriate.
- Do not store secrets, tokens, credentials, or sensitive customer data in source control or test fixtures.
- Agentforce grounding, topics, actions, and prompt templates must follow the org's data access policies. Restrict data sources/actions and validate outputs with staff before customer-facing use.

The included permission set is an agent capability set, not a complete org-wide user provisioning policy. Give supervisors additional rights through a separately approved permission set.
