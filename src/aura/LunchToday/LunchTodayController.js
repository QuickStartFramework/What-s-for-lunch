({
    doInit : function(component, event, helper) {
        var today = new Date();
        var strToday = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
        component.set("v.todayDate", strToday);
        
        var getLunchMenu = component.get("c.todaysLunch");
        getLunchMenu.setCallback(this, function(a){
            //console.log(a.getReturnValue());
            component.set("v.lunch", a.getReturnValue());
            component.set("v.lunchDescription", a.getReturnValue());
        });
        $A.enqueueAction(getLunchMenu);
        
        var displayLunchMeetups = component.get("v.displayLunchMeetups");
        if (displayLunchMeetups == true) {
            helper.loadLunchMeetups(component);
        }
    },
    
    viewTodayMenu : function(component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.lunch.Id")
        });
        navEvt.fire();
    },
    
    newLunchMeetup : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Lunch_Meetup__c"
        });
        createRecordEvent.fire();
    },
    
    viewLunchMeetup: function(component, event) {
        var index = event.target.dataset.index;
        var recordId = component.get("v.lunchMeetups")[index].Id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    },
    
    viewLunchMeetups: function(component, event) {
        var navEvt = $A.get("e.force:navigateToObjectHome");
        navEvt.setParams({
            "scope": 'Lunch_Meetup__c'
        });
        navEvt.fire();
    }
})