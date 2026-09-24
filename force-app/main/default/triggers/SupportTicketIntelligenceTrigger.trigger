trigger SupportTicketIntelligenceTrigger on Support_Ticket__c (before insert, before update) {
    SupportTicketPriorityService.classify(Trigger.new);
    if (Trigger.isInsert) SupportTicketPriorityService.assignAgents(Trigger.new);
}
