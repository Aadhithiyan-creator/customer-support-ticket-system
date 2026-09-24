# Architecture

`Support_Ticket__c` stores the service record. Before-save trigger logic delegates to `SupportTicketPriorityService`: classification runs for inserts and description changes through updates; assignment runs on insert for tickets without an agent. Assignment candidate users are active users assigned `Support_Ticket_Agent`; candidate loads count non-resolved tickets. The tie break is by user ID for deterministic selection.

An after-save record-triggered Flow starts when priority is High and the task-created flag is false. It creates a high-priority Task linked through `WhatId`, then sets the flag. That flag change makes subsequent runs exit at the start condition. Flow owner falls back to the current user when no agent is set.

The Lightning app provides navigation. The custom object layout, list views, and page metadata provide a usable record experience. Dashboard components and app/page activation should be configured in the target org because they depend on available reports and org configuration.

## Limits and extension points

Assignment is balanced by count, not by skill, language, presence, or capacity. Concurrent ticket transactions can observe the same workload snapshot. For production routing, consider Omni-Channel, queues, skills-based routing, and a persistent round-robin allocator. Classification is deterministic keyword matching and is not an ML prediction. Agentforce must not be treated as an autonomous source of truth for urgency or resolution.
