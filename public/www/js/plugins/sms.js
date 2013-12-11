var native_accessor = {

    send_sms: function (phone, message) {
        alert(phone+","+message);
        native_access.send_sms({"receivers": [
            {"name": 'name', "phone": phone}
        ]}, {"message_content": message});
    },

    receive_message: function (json_message) {
        if (typeof this.process_received_message === 'function') {
            this.process_received_message(json_message)
        }
    },
    process_received_message: function (message) {
        var message_front = (message["messages"][0]["message"]).substring(0,2).toLocaleUpperCase();
        if (message_front == "BM") {
            message_enroll.bm(message) ;
            activity_enroll_page_refresh();
        }
        else if(message_front == "JJ"){
            message_enroll.bid(message)
            bid_sign_up_page_refresh()
        }
    }
}

function notify_message_received(message_json) {
    //console.log(JSON.stringify(message_json));
    //JSON.stringify(message_json);
    //alert(JSON.stringify(message_json.messages));
    native_accessor.receive_message(message_json);
    //phone_number=message_json.messages[0].phone;
}