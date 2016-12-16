trigger Lunch_Meetup_Updated on Lunch_Meetup__c (after update, after delete) {
    try {
        System.debug('Lunch Management - SynchLunchMeetupWithEvent');
        
        //Get LunchMeetup Object - For Update or delete Trigger Event
        Lunch_Meetup__c lm;
        Lunch_Meetup__c oldlm;
        
        if (trigger.isDelete == false)
        {   
            lm = Trigger.new[0];
            oldlm = Trigger.old[0];
        }
        else
            lm = Trigger.old[0];
        
        //Get Event in Calendar related to existing LunchMeetup
        List<Event> le = [select id, subject, location, StartDateTime, EndDateTime, WhatId, OwnerId
                          from Event
                          where 
                          WhatId =: lm.Id AND OwnerId =: lm.CreatedById
                         ];
        
        //If the Event does not exist but Lunch Meetup does, then recreating it        
        if (le == null || le.size() == 0)
        {
            System.debug('Lunch Management - Warning - Event did not exist but Lunch Meetup exists, recreating the event for owner');            
            Event e = new Event();
            e.StartDateTime = lm.Date__c;
            e.EndDateTime = lm.Date__c + 1/24;
            e.Location = lm.Address__c;
            e.Subject = lm.Name__c;
            e.OwnerId = lm.CreatedById;
            e.WhatId = lm.Id;
            upsert(e);
            return;
        }
        
        //If Lunch Meetup has been deleted then delete event for owner
        Event e = le.get(0);
        if (trigger.isDelete == true)
        {
            delete(e);
            return;
        }
        
        //Else, Synch Event from Lunch Meetup Update
        DateTime myDateTime = lm.Date__c;
        e.StartDateTime = myDateTime;
        e.EndDateTime = myDateTime.addHours(1);
        e.Location = lm.Address__c;
        e.Subject = lm.Name__c;
        
        update(e);
        
    } catch (Exception e) {
        System.debug('Lunch Management - Error while synching Event and Lunch Meetup, m=' + e.getMessage());
    }
}