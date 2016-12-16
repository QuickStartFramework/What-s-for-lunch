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
    },
    
    addUserToSelectedLunchMeetup: function(component, event) {
        var index = event.getSource().get("v.value");
        var recordId = component.get("v.lunchMeetups")[index].Id;
        console.log(recordId);
        var addUserAction = component.get("c.addUserToLunchMeetup");
        addUserAction.setParams({ lunchMeetup : recordId});
        addUserAction.setCallback(this, function(a) {
            var toastEvent = $A.get("e.force:showToast");
            if (a.getReturnValue() == 'Added') {
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "You are registered to the Lunch Meetup.",
                    'type' : 'success'
                });
            } else {
                toastEvent.setParams({
                    "title": 'Warning',
                    "message": a.getReturnValue(),
                    "type": 'Warning'
                });
            }
                
            toastEvent.fire();
        });
        $A.enqueueAction(addUserAction);
    }
})