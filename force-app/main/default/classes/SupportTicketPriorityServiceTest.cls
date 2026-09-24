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
        Id currentAdminId = UserInfo.getUserId();
        Test.startTest();
        insert tickets;
        Test.stopTest();
        System.assertEquals(200, [SELECT COUNT() FROM Support_Ticket__c WHERE Priority__c='High']);
    }

    @IsTest static void assignsNewTicketToLeastLoadedDesignatedAgent() {
        String suffix = String.valueOf(DateTime.now().getTime()) + '.' + String.valueOf(Crypto.getRandomInteger()).replace('-', 'n');
        Id profileId = UserInfo.getProfileId();
        List<User> agents = new List<User>{
            new User(Alias='agent1', Email='agent1+' + suffix + '@example.test', EmailEncodingKey='UTF-8',
                LastName='Support Agent One', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                ProfileId=profileId, TimeZoneSidKey='America/Los_Angeles', Username='agent1+' + suffix + '@example.test'),
            new User(Alias='agent2', Email='agent2+' + suffix + '@example.test', EmailEncodingKey='UTF-8',
                LastName='Support Agent Two', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                ProfileId=profileId, TimeZoneSidKey='America/Los_Angeles', Username='agent2+' + suffix + '@example.test')
        };
        insert agents;
        PermissionSet agentPermission = [SELECT Id FROM PermissionSet WHERE Name='Support_Ticket_Agent' LIMIT 1];
        insert new List<PermissionSetAssignment>{
            new PermissionSetAssignment(AssigneeId=agents[0].Id, PermissionSetId=agentPermission.Id),
            new PermissionSetAssignment(AssigneeId=agents[1].Id, PermissionSetId=agentPermission.Id)
        };

        Id currentAdminId = UserInfo.getUserId();
        Test.startTest();
        Support_Ticket__c unassigned = new Support_Ticket__c(Description__c='How do I update a profile?');
        System.runAs(agents[1]) {
            insert new List<Support_Ticket__c>{
                new Support_Ticket__c(Description__c='Question about an invoice', Status__c='New', Assigned_Agent__c=agents[0].Id),
                new Support_Ticket__c(Description__c='Question about an account', Status__c='New', Assigned_Agent__c=currentAdminId)
            };
            insert unassigned;
        }
        Test.stopTest();

        Support_Ticket__c saved = [SELECT Assigned_Agent__c, OwnerId FROM Support_Ticket__c WHERE Id=:unassigned.Id];
        System.assertEquals(agents[1].Id, saved.Assigned_Agent__c, 'The agent with the lower open workload should receive the ticket.');
        System.assertEquals(agents[1].Id, saved.OwnerId, 'Auto-assignment should align the record owner with the assigned agent.');
    }
}
