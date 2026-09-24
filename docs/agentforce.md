# Agentforce setup guide

This repository does not include invented Agentforce metadata. Available Agentforce objects and deployment formats vary by Salesforce release and org licensing. Configure and test the agent in Setup after deploying the core project.

## Suggested configuration

1. Confirm Agentforce is enabled and licensed in the target sandbox. Open **Setup → Agentforce Agents** and create a service agent for support staff.
2. Name it **Support Ticket Assistant**. Add a clear description: assists authorized agents with ticket analysis, summaries, priority suggestions, assignment recommendations, and resolution guidance. Require human review for priority, assignment, and customer-facing responses.
3. Add topics such as **Analyze a Ticket**, **Summarize a Ticket**, **Recommend an Owner**, and **Suggest Resolution**. Scope each topic to the selected `Support_Ticket__c` record and its related Account/Contact only when the current user has access.
4. Add read-only grounding first: Support Ticket fields, approved Knowledge articles, and a narrowly scoped report/data source. Exclude secrets and unrelated customer data. Follow least-privilege sharing and field-level security.
5. For write actions, create or select Flow actions that update `AI_Analysis__c` or `Resolution_Notes__c` only after agent confirmation. Do not allow Agentforce to overwrite `Priority__c` or `Assigned_Agent__c`; deterministic Apex owns those values. Keep the routing recommendation advisory.
6. Provide response instructions: cite the ticket facts used; distinguish observed facts from suggestions; state uncertainty; never infer sensitive customer attributes; escalate security incidents and production outages; do not promise resolution or SLA outcomes.
7. Add the Agentforce component to the ticket Lightning record page and the app home page if supported in the org. Activate for the intended app/profile audience only.
8. Test with representative High/Medium/Low records, permission-restricted users, missing data, and adversarial descriptions. Verify no record can be surfaced or changed outside the user's Salesforce access. Have support staff review suggestions before activation.

## Capabilities to demonstrate

- **Ticket analysis:** summarize facts in description and related fields.
- **Priority recommendation:** compare description against the project's explicit priority rules and explain mismatch or uncertainty. The Apex value remains authoritative.
- **Ticket summary:** return a concise summary of issue, customer impact, status, owner, and next step.
- **Assignment recommendation:** suggest an eligible agent based on skills/availability only when those signals are explicitly configured; otherwise state the workload-based Apex assignee.
- **Resolution assistance:** search approved Knowledge and propose troubleshooting steps; require an agent to approve and record a resolution.

Do not enable customer-facing autonomous replies until the org's privacy, safety, and escalation review is complete.
