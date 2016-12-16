({
	loadLunchMeetups : function(component) {
		var getLunchMeetups = component.get("c.todaysLunchMeetups");
        getLunchMeetups.setCallback(this, function(a){
            component.set("v.lunchMeetups", a.getReturnValue());
        });
        $A.enqueueAction(getLunchMeetups);
	}
})