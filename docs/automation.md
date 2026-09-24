# Automation

## Classification and assignment

`SupportTicketIntelligenceTrigger` calls `SupportTicketPriorityService` before insert and update. Classification reads `Description__c`, prioritizes High matches over Medium matches, and always records `Priority_Reason__c`. Assignment runs on insert only and skips any ticket with an explicit agent. It selects the active, designated agent with the fewest non-resolved tickets. When no agent candidate exists, assignment safely stays blank.

The agent pool is opt-in: assign the `Support_Ticket_Agent` permission set to each eligible active user. The permission set grants limited ticket create/read/edit access and no delete, view-all, or modify-all access. Review object/field access for non-agents separately.

## High priority follow-up

The `Support_Ticket_High_Priority_Follow_Up` after-save Flow creates a high-priority Task when the ticket priority is High and `High_Priority_Task_Created__c` is false. It links the Task to the ticket, assigns it to the support agent or current user, then marks the flag true. The Flow does not re-enter its action path after setting the guard. If Task creation fails, the transaction rolls back and no flag is left behind.

Classification is re-evaluated on update and may move priority up or down. Task creation is intentionally once-per-ticket, not once per subsequent high-priority transition. To support repeated escalations, replace the checkbox guard with a deduplication key/object keyed by ticket and escalation event.
