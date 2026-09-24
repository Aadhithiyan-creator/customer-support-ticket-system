# Requirements

## User stories

- Support staff capture customer issues and see a stable ticket number, state, urgency, owner, and resolution notes.
- The system classifies descriptions as High, Medium, or Low and stores a human-readable reason.
- Unassigned new tickets route to active users explicitly enrolled as ticket agents, balancing open workload.
- High tickets create a single follow-up Task, assigned to the ticket agent or ticket-creating user.
- Supervisors use list views, reports, and dashboards to monitor urgency and workload.
- Agentforce can assist staff when the org has the relevant licenses and approved actions.

## Priority rules

High terms: urgent, critical, failure, system down, payment failed, security issue, cannot login, production down. Medium terms: slow, error, issue, problem, delayed, intermittent. Matching is case-insensitive substring matching; High wins when both sets match. Otherwise priority is Low.

## Platform constraints

The app requires Salesforce DX deployment access. Agentforce availability and metadata depend on org edition, licenses, and release. Report charts require data. Layout activation, app assignment, permission assignment, and Agentforce publication are org-specific setup tasks described in the guides.
