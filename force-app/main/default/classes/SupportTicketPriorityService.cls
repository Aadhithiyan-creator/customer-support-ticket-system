public with sharing class SupportTicketPriorityService {
    private static final List<String> HIGH_TERMS = new List<String>{
        'urgent', 'critical', 'failure', 'system down', 'payment failed',
        'security issue', 'cannot login', 'production down'
    };
    private static final List<String> MEDIUM_TERMS = new List<String>{
        'slow', 'error', 'issue', 'problem', 'delayed', 'intermittent'
    };

    public static void classify(List<Support_Ticket__c> tickets) {
        if (tickets == null) return;
        for (Support_Ticket__c ticket : tickets) {
            if (ticket == null) continue;
            String text = ticket.Description__c == null ? '' : ticket.Description__c.toLowerCase();
            String priority = 'Low';
            String reason = 'No high or medium priority keywords were found.';
            for (String term : HIGH_TERMS) {
                if (text.contains(term)) {
                    priority = 'High';
                    reason = 'Description contains high urgency keyword: ' + term + '.';
                    break;
                }
            }
            if (priority == 'Low') {
                for (String term : MEDIUM_TERMS) {
                    if (text.contains(term)) {
                        priority = 'Medium';
                        reason = 'Description contains medium urgency keyword: ' + term + '.';
                        break;
                    }
                }
            }
            ticket.Priority__c = priority;
            ticket.Priority_Reason__c = reason;
        }
    }

    // Uses ticket volume to select the least-loaded active users explicitly
    // designated as support agents by the Support_Ticket_Agent permission set.
    public static void assignAgents(List<Support_Ticket__c> tickets) {
        if (tickets == null || tickets.isEmpty()) return;
        List<Support_Ticket__c> unassigned = new List<Support_Ticket__c>();
        for (Support_Ticket__c t : tickets) {
            if (t != null && t.Assigned_Agent__c == null) unassigned.add(t);
        }
        if (unassigned.isEmpty()) return;

        Set<Id> agentIds = new Set<Id>();
        for (PermissionSetAssignment assignment : [
            SELECT AssigneeId FROM PermissionSetAssignment
            WHERE PermissionSet.Name = 'Support_Ticket_Agent'
            AND Assignee.IsActive = true
        ]) agentIds.add(assignment.AssigneeId);
        if (agentIds.isEmpty()) return;

        Map<Id, Integer> workload = new Map<Id, Integer>();
        for (Id agentId : agentIds) workload.put(agentId, 0);
        for (AggregateResult row : [
            SELECT Assigned_Agent__c agentId, COUNT(Id) ticketCount
            FROM Support_Ticket__c
            WHERE Assigned_Agent__c IN :agentIds AND Status__c != 'Resolved'
            GROUP BY Assigned_Agent__c
        ]) workload.put((Id)row.get('agentId'), (Integer)row.get('ticketCount'));

        List<Id> orderedAgents = new List<Id>(agentIds);
        orderedAgents.sort();
        for (Support_Ticket__c ticket : unassigned) {
            Id selected;
            Integer lowest = 2147483647;
            for (Id agentId : orderedAgents) {
                Integer count = workload.get(agentId);
                if (count < lowest) { lowest = count; selected = agentId; }
            }
            if (selected != null) {
                ticket.Assigned_Agent__c = selected;
                workload.put(selected, workload.get(selected) + 1);
            }
        }
    }
}
