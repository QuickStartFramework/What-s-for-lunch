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
                                         Type__c, CreatedBy.SmallPhotoUrl, Host_Profile_Picture__c 
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