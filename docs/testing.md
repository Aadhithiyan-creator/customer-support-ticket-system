# Testing

`SupportTicketPriorityServiceTest` covers High, Medium, Low, null descriptions, bulk inserts, and graceful operation with an empty designated-agent pool. Salesforce Apex tests must run in an authenticated org because this environment has no Salesforce CLI or org connection.

In a sandbox:

```powershell
sf apex run test --source-dir force-app/main/default/classes --target-org support-dev --result-format human --code-coverage
sf project deploy validate --source-dir force-app --target-org support-dev --test-level RunLocalTests
```

Manual integration checks:

1. Insert descriptions matching each priority group and verify `Priority__c` and `Priority_Reason__c`.
2. Add two eligible agents, create unassigned tickets, and verify assignment chooses the lower open workload.
3. Create a High ticket and confirm exactly one Task is created and assigned correctly.
4. Edit the ticket after task creation and confirm the Flow does not make a duplicate.
5. Confirm users without the agent permission set are not assignment candidates.
