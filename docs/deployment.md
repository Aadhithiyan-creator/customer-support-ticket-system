# Deployment

## Prerequisites

- Salesforce CLI (`sf`) and access to a development or sandbox org.
- Permission to deploy Apex, custom objects, Flow, Lightning app metadata, and permission sets.
- A user or integration identity approved for sandbox deployment.

## Validate and deploy

```powershell
sf org login web --alias support-dev --instance-url https://test.salesforce.com
sf org list
sf project deploy validate --source-dir force-app --target-org support-dev --test-level RunLocalTests
sf project deploy start --source-dir force-app --target-org support-dev
sf org assign permset --name Support_Ticket_Agent --target-org support-dev
```

Assign the permission set only to approved support agents. Configure Lightning pages, page/app activation, reports, dashboard and Agentforce following the relevant docs. Check object sharing and sharing rules in the org; the custom object defaults to Private.

## Rollback

Use a reviewed destructive changes deployment only when removing metadata. For initial setup, deactivating the Flow and removing the app from user navigation are reversible. Back up existing org metadata and data before production rollout.

This repository was not deployed or validated against an org in its authoring environment because Salesforce CLI and authenticated orgs were unavailable. Run the validation command before deployment and resolve any org/API-version-specific metadata errors first.
