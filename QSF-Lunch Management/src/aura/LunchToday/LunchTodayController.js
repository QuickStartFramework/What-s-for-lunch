({
	doInit : function(component, event, helper) {
        var today = new Date();
        var strToday = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
        component.set("v.todayDate", strToday);
        
		var getLunchMenu = component.get("c.todaysLunch");
        getLunchMenu.setCallback(this, function(a){
            console.log(a.getReturnValue());
            component.set("v.lunch", a.getReturnValue());
            component.set("v.lunchDescription", a.getReturnValue());
        });
        $A.enqueueAction(getLunchMenu);
	},
    
    viewTodayMenu : function(component, event) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.lunch.Id")
        });
        navEvt.fire();
    }
})