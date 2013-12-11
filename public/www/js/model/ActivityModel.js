function Activity(name,order,status,user){
    this.name = name
    this.order = order
    this.status = status
    this.user = user
}

Activity.ActivityEnrollBegin = function(){
    localStorage.setItem("enrolling_activity_name", localStorage.getItem("ActivityName"));
    Activity.SetUnstartedActivity("no");
    localStorage.setItem(localStorage.getItem("enrolling_activity_name"), JSON.stringify([]));
}

Activity.ActivityEnrollEnd = function(){
    localStorage.setItem("enrolling_activity_name", "");
    Bid.SetBidingName("null");
}

Activity.SetActivityName = function(activity_name){
    localStorage.setItem("ActivityName",activity_name);
}

Activity.GetActivityName = function(){
    return localStorage.getItem("ActivityName")  ;
}

Activity.GetActivityArray =function(){
    var activity_array = JSON.parse(localStorage.getItem("ActivityArray")) || [] ;
    return activity_array
}

Activity.GetUserActivityArray = function(){
    return _.where(Activity.GetActivityArray(),{'user' : localStorage.current_user} )
}

Activity.GetUserActivityEnrollInfo = function(){
    var name_array= _.pluck(Activity.GetUserActivityArray(),'name') ;
    return _.flatten(_.map(name_array,function(ob){var user_enroll=Activity.GetActivityEnrollInfo(ob); return _.map(user_enroll,function(obe){obe.activity=ob;obe.user=localStorage.current_user;return obe;})}))
}

//Activity.addActivity =function(activity_name){
//    return _.map(Activity.GetActivityEnrollInfo(activity_name),function(ob){ob.activity= activity_name})
//}

Activity.GetActivityEnrollInfo = function(activity_name){
    return JSON.parse(localStorage.getItem(activity_name))  ;
}

Activity.GetEnrollingActivityName = function(){
    var enrolling_activity_name = localStorage.getItem("enrolling_activity_name") || "" ;
    return enrolling_activity_name ;
}

Activity.SetUnstartedActivity = function(checked){
    localStorage.setItem("created_unstarted_activity", checked);
}

Activity.ActivityEnrollNumber = function(){
    var message_array = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName"))) || [];
    return message_array.length;
}

Activity.PushNewActivity = function(input_activity_name){
    var ActivityArray = Activity.GetActivityArray();
    var temp = new Activity(input_activity_name,ActivityArray.length + 1,"未开始",localStorage.current_user);
    ActivityArray.push(temp);
    localStorage.setItem("ActivityName", input_activity_name);
    localStorage.setItem("ActivityArray", JSON.stringify(ActivityArray));
}

Activity.ActivityStatusChange = function(activity_number,status_string){
    var activity_temp ={},activity_array_temp=[];
    activity_temp=Activity.GetActivityArray()[activity_number] ;
    activity_array_temp= Activity.GetActivityArray();
    activity_temp["status"]=status_string;
    activity_array_temp[activity_number]=activity_temp;
    localStorage.setItem("ActivityArray",JSON.stringify(activity_array_temp)) ;
}

Activity.ActivitySearch = function(activity_array,activity_name){
    var index=_.chain(activity_array)
        .pluck("name")
        .indexOf(activity_name)
        .value()
    return index
}