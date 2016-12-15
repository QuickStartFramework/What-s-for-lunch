public class LunchController {
    
    @AuraEnabled
    public static Lunch__c todaysLunch() {
        Lunch__c lunch = null;
        lunch = buildTodaysLunchMenu();
        return lunch;
    }
    
    private static Lunch__c buildTodaysLunchMenu() {
        try {
            Lunch__c todaysLunch = [select id, name, Lunch_Meetups__c,
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
}