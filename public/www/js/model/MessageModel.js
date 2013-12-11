function message_enroll(phone,enroll_name){
    this.phone = phone ;
    this.enroll_name = enroll_name ;
}

message_enroll.prototype.pro = function(){
    this.enroll_name = (this.enroll_name).trim()
}

message_enroll.get_phone =function (message){
    return  message["messages"][0]["phone"] ;
}

message_enroll.activity_status_check = function (message){
    if (Activity.GetEnrollingActivityName() == "" ){
       return message_enroll.unstarted_activity_check(message)
    }
    message_enroll.phone_number_checked(message)
}

message_enroll.unstarted_activity_check = function (message){
    if(localStorage.getItem("created_unstarted_activity") == "yes") {
        return native_accessor.send_sms(message_enroll.get_phone(message), "活动尚未开始，请稍后")
    }
    native_accessor.send_sms(message_enroll.get_phone(message), "Sorry,活动报名已结束")
}

message_enroll.phone_number_checked = function(message){
    var message_array = JSON.parse(localStorage.getItem(localStorage.getItem("enrolling_activity_name"))) || [];
    var message_object_temp = new message_enroll(message["messages"][0]["phone"],(message["messages"][0]["message"]).substring(2));
    message_object_temp.pro()
    var phone_number_checked = _.some(message_array,function(ob){return ob.phone == message_object_temp["phone"]});
    if(phone_number_checked == true){
        return native_accessor.send_sms(message_object_temp["phone"], "您已经报名成功，请勿重复报名！")
    }
    message_array.push(message_object_temp);
    localStorage.setItem(localStorage.getItem("enrolling_activity_name"), JSON.stringify(message_array));
    native_accessor.send_sms(message_object_temp["phone"], "恭喜！报名成功")
}

message_enroll.bm = function (message){
    message_enroll.activity_status_check(message);
}

message_enroll.bid_status_check = function (message){
    if(localStorage.getItem("biding_name") == "null" ){
        return message_enroll.bid_end_or_unstarted_check(message);
    }
    message_enroll.bid_already_checked(message)
}

message_enroll.bid_end_or_unstarted_check = function (message){
    if(localStorage.getItem(localStorage.getItem("ActivityName")+"竞价") != undefined) {
        return native_accessor.send_sms(message_enroll.get_phone(message), "对不起，活动已结束！")
    }
    native_accessor.send_sms(message_enroll.get_phone(message), "对不起，活动尚未开始！")
}

message_enroll.bid_already_checked = function(message){
    var bid_array_temp = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + localStorage.getItem("biding_name"))) || [];
    var activity_enroll_temp = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName"))) || [];
    var bid_object_temp = new BidInfo((_.find(activity_enroll_temp,function(ob){return ob.phone == message["messages"][0]["phone"]})).enroll_name,message["messages"][0]["phone"],(message["messages"][0]["message"]).substring(2), bid_array_temp.length + 1);
    var bid_already_checked = _.some(bid_array_temp,function(ob){return ob.phone == bid_object_temp["phone"]});
    if (!bid_already_checked){
        bid_object_temp.pro() ;
        bid_array_temp.push(bid_object_temp);
        localStorage.setItem(localStorage.getItem("ActivityName") + localStorage.getItem("biding_name"), JSON.stringify(bid_array_temp))
        return native_accessor.send_sms(message_enroll.get_phone(message), "恭喜！您已成功出价")
    }
    native_accessor.send_sms(message_enroll.get_phone(message), "您已成功出价，请勿重复出价！")
}

message_enroll.bid =function (message){
    message_enroll.bid_status_check(message);
}