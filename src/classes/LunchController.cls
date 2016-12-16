public class LunchController {
    
    @AuraEnabled
    public static Lunch__c todaysLunch() {
        Lunch__c lunch = null;
        lunch = buildTodaysLunchMenu();
        return lunch;
    }
    
    @AuraEnabled
    public static List<Lunch_Meetup__c> todaysLunchMeetups() {
        List<Lunch_Meetup__c> lms = null;
        lms = buildTodaysLunchMeetups();
        return lms;
    }
    
    @AuraEnabled
    public static List<String> todaysLunchMeetupsHosts() {
        List<String> lmh = null;
        lmh = buildTodaysLunchMeetupsHosts();
        return lmh;
    }
    
    @AuraEnabled
    public static String addUserToLunchMeetup(String lunchMeetup) {
        String userId = UserInfo.getUserId();
        try {
            System.debug('Lunch Management - ' + userId + ' - ' + lunchMeetup);
            
            Event e = [select id, subject, StartDateTime, WhatId, OwnerId
                       from Event where WhatId =: lunchMeetup limit 1];
            
            EventRelation er = new EventRelation(EventId = e.Id, 
                                                 RelationId = userId);
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail  = true;
            dlo.EmailHeader.triggerOtherEmail  = true;
            dlo.EmailHeader.triggerAutoResponseEmail = false;
            Database.insert(er,dlo);
            
            //Verify if Participant already exists
            List<Lunch_Participant__c> lpT = [select id, name from Lunch_Participant__c
                                              where User__c =: userId AND Lunch_Meetup__c =: lunchMeetup];
            if (lpT != null && lpT.size() > 0)
            {
                System.debug('Lunch Management - Participant is already attending the lunch meetup');
                return 'You are already attending this lunch meetup';
            }
            
            //Create Participant
            Lunch_Participant__c lp = new Lunch_Participant__c();
            lp.User__c = userId;
            lp.Lunch_Meetup__c = lunchMeetup;
            insert(lp);
            
            return 'Added';
        }
        catch (Exception ex) {
            System.debug('Lunch Management - Error while adding Participant to Calendar Event, m=' + ex.getMessage());
            return 'Error while adding Participant to Calendar Event, m=' + ex.getMessage();
        }
    }
    
    private static List<Lunch_Meetup__c> getLunchMeetups() {
        try {
            List<Lunch_Meetup__c> lms = [select id, Name__c,
                                         Address__c, Date__c,
                                         Type__c, CreatedById
                                         from Lunch_Meetup__c WHERE Date__c = TODAY LIMIT 10 ];
            return lms;
        }
        catch (Exception e) {
            System.debug('Lunch - Cannot retrieve lunch meetups for today, m=' + e.getMessage());
            return null;
        }
    }
    
    private static List<String> buildTodaysLunchMeetupsHosts() {
        List<String> lmHosts = new List<String>();
        List<String> lmHostIDs = new List<String>();
        
        List<Lunch_Meetup__c> lms = buildTodaysLunchMeetups();
        for (Lunch_Meetup__c lm : lms) {
            lmHostIDs.add(lm.CreatedById);
        }
        
        List<User> users = [select id, Name, SmallPhotoUrl from User Where id IN :lmHostIDs];
        for (User u : users)
            lmHosts.add(u.SmallPhotoUrl);
        return lmHosts;
    }
    
    private static Lunch__c buildTodaysLunchMenu() {
        try {
            Lunch__c todaysLunch = [select id, name,
                                    Appetizer__c, Course__c, Date__c,
                                    Desert__c, Special_Menu__c, Status__c, Type__c, RecordTypeId
                                    from Lunch__c WHERE Date__c = TODAY AND Status__c = 'Lunch menu ready' LIMIT 1 ];
            
            if (todaysLunch == null)
                return null;
            
            return todaysLunch;
        } catch (Exception e) {
            System.debug('Lunch - Cannot retrieve todays lunch, m=' + e.getMessage());
            return null;
        }
    }
    
    private static List<Lunch_Meetup__c> buildTodaysLunchMeetups() {
        try {
            List<Lunch_Meetup__c> lms = [select id, Name__c,
                                         Address__c, Date__c,
                                         Type__c, CreatedBy.SmallPhotoUrl 
                                         from Lunch_Meetup__c WHERE Date__c = TODAY LIMIT 10 ];
            
            if (lms == null)
                return null;
            
            return lms;
        } catch (Exception e) {
            System.debug('Lunch - Cannot retrieve todays lunch meetups, m=' + e.getMessage());
            return null;
        }
    }
}