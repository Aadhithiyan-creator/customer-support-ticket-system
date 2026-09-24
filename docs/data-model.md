# Data model

| Salesforce field | Type | Purpose |
|---|---|---|
| `Name` | Auto Number `ST-{00000}` | Ticket number |
| `Customer__c` | Contact lookup | Requesting customer |
| `Account__c` | Account lookup | Customer organization |
| `Description__c` | Long text | Issue description; classifier input |
| `Status__c` | Picklist | New, In Progress, Waiting on Customer, Resolved |
| `Priority__c` | Picklist | High, Medium, Low; Apex managed |
| `Priority_Reason__c` | Text | Keyword-based explanation |
| `Assigned_Agent__c` | User lookup | Routed support agent |
| `AI_Analysis__c` | Long text | Optional reviewed Agentforce analysis |
| `Resolution_Notes__c` | Long text | Resolution details |
| `SLA_Status__c` | Picklist | On Track, At Risk, Breached |
| `High_Priority_Task_Created__c` | Checkbox | Flow idempotency guard |

Tasks use `WhatId` to relate to the ticket. The record owner remains Salesforce's standard `OwnerId`; the explicit support assignee is `Assigned_Agent__c`.
