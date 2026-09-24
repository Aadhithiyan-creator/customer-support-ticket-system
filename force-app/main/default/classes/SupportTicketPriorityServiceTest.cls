@IsTest
private class SupportTicketPriorityServiceTest {
    @IsTest static void classifiesEveryPriorityAndNullDescription() {
        List<Support_Ticket__c> tickets = new List<Support_Ticket__c>{
            new Support_Ticket__c(Description__c='Production down after a critical failure'),
            new Support_Ticket__c(Description__c='Intermittent error when saving'),
            new Support_Ticket__c(Description__c='How do I update my profile?'),
            new Support_Ticket__c()
        };
        SupportTicketPriorityService.classify(tickets);
        System.assertEquals('High', tickets[0].Priority__c);
        System.assert(tickets[0].Priority_Reason__c.contains('high urgency'));
        System.assertEquals('Medium', tickets[1].Priority__c);
        System.assertEquals('Low', tickets[2].Priority__c);
        System.assertEquals('Low', tickets[3].Priority__c);
    }

    @IsTest static void bulkInsertAndNoAgentIsSafe() {
        List<Support_Ticket__c> tickets = new List<Support_Ticket__c>();
        for (Integer i = 0; i < 200; i++) tickets.add(new Support_Ticket__c(Description__c='Payment failed'));
        Test.startTest();
        insert tickets;
        Test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM Support_Ticket__c WHERE Priority__c='High']);
    }
}
