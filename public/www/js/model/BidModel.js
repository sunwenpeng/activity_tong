function Bid(name, bid_order, status) {
    this.name = name
    this.bid_order = bid_order
    this.status = status
}

Bid.SetBidName = function (bid_name) {
    localStorage.setItem("bid_name", bid_name);
}

Bid.SetBidingName = function (biding_name) {
    localStorage.setItem("biding_name", biding_name);
}

Bid.SetBidBeginChecked = function (checked) {
    localStorage.setItem("bid_begin_checked", checked);
}

Bid.GetBidBeginChecked = function () {
    return JSON.parse(localStorage.getItem("bid_begin_checked"))
}

Bid.SetBidSignUpChecked = function (checked) {
    localStorage.setItem("bid_sign_up_checked", checked);
}

Bid.SetBidCreateChecked = function (checked) {
    localStorage.setItem("bid_create_checked", checked);
}

Bid.SetBidCollectedInfo = function (bid_info_array_new) {
    localStorage.setItem("竞价统计信息", JSON.stringify(Bid.BidPriceClassify(bid_info_array_new)))
}

Bid.GetBidCollectedInfo = function () {
    return JSON.parse(localStorage.getItem("竞价统计信息"))
}

Bid.GetActivityBid = function (activity_name) {
    return JSON.parse(localStorage.getItem(activity_name + "竞价")) || []
}

Bid.GetUserBids =function(){
    var name_array= _.pluck(Activity.GetUserActivityArray(),'name') ;
    return _.flatten(_.map(name_array,function(name){var bids= Bid.GetActivityBid(name);return _.map(bids,function(ob){ob.activity=name;ob.user=localStorage.current_user;return ob;})}))
}

Bid.GetUserBidUps = function(){
    var bid_up_name = _.map(Bid.GetUserBids(),function(ob){return ob.activity+ ob.name});
    return _.flatten(_.map(bid_up_name,function(name){var bids=JSON.parse(localStorage.getItem(name));return _.map(bids,function(ob){var index=name.indexOf("竞价"); ob.bid_name=name.substring(index);ob.activity=name.substring(0,index);ob.user=localStorage.current_user;return ob;})}))
}

Bid.GetBidInfoArrayNew = function () {
    var bid_info_array_new = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + localStorage.getItem("bid_name"))) || [];
    return bid_info_array_new;
}

Bid.GetUserBidResults = function(){
    var bids = _.where(Bid.GetUserBids(),{status:'已结束'});
    return _.map(bids,function(ob){var bid_info=JSON.parse(localStorage.getItem(ob.activity+ob.name));var index=Bid.BidPriceResultIndex(bid_info);if(index==-1){ob.suc_person = '';ob.phone='';ob.price=-1;return ob;}else{ob.suc_person=bid_info[index].name;ob.phone=bid_info[index].phone;ob.price=bid_info[index].price;return ob;}})
}

Bid.SetBidSuccessPersonInfo = function () {
    var bid_success_person_index = Bid.BidPriceResultIndex(bid_info_array_new);
    if (bid_success_person_index != -1) {
        localStorage.setItem("竞价成功人信息", JSON.stringify(bid_info_array_new[bid_success_person_index]))
    }
    else{
        var bid_info_array_new = Bid.GetBidInfoArrayNew();
        localStorage.setItem("竞价成功人信息",JSON.stringify([]));
    }
}

Bid.BidSuccessPersonInfo = function () {
    var result_info = JSON.parse(localStorage.getItem("竞价成功人信息")) || [];
    if (JSON.stringify(result_info) != JSON.stringify([])) {
        var bid_success_person_info = "竞价结果：    " + result_info["name"] + "  " + (result_info["price"]).toString() + "元" + "        " + result_info["phone"]
        return bid_success_person_info;
    }
    else {
        return "竞价失败";
    }
}

Bid.BidSignUpNameAndNumber = function () {
    var bid_info_array_new = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + localStorage.getItem("bid_name"))) || [];
    var sign_up_number = bid_info_array_new.length;
    var bid_sign_up_name_and_number = localStorage.getItem("bid_name") + "(" + sign_up_number.toString() + "人)";
    return bid_sign_up_name_and_number
}

Bid.GetBidStatus = function () {
    var i = Bid.BidNameSearch(localStorage.getItem("bid_name"), localStorage.getItem("ActivityName") + "竞价")
    return JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + "竞价"))[i]["status"];
}

Bid.GetBidSuccessPersonInfo = function () {
    var result_info = JSON.parse(localStorage.getItem("竞价成功人信息"));
    return result_info;
}

Bid.PushNewBid = function () {
    var bid_array = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + "竞价")) || [];
    var bid_object = {};
    bid_object["name"] = "竞价" + (bid_array.length + 1).toString();
    bid_object["bid_order"] = bid_array.length + 1;
    bid_object["status"] = "biding"
    bid_array.push(bid_object);
    localStorage.setItem(localStorage.getItem("ActivityName") + "竞价", JSON.stringify(bid_array));
    localStorage.setItem("biding_name", bid_object["name"]);
    localStorage.setItem("bid_name", bid_object["name"]);
}

Bid.BidNameSearch = function (bid_name, activity_bid_name) {
    var bid_array = JSON.parse(localStorage.getItem(activity_bid_name));
    var index = _.chain(bid_array)
        .pluck("name")
        .indexOf(bid_name)
        .value()
    return index
}

Bid.BidStatusChange = function () {
    var bid_array = JSON.parse(localStorage.getItem(localStorage.getItem("ActivityName") + "竞价"));
    var activity_bid_number = Bid.BidNameSearch(localStorage.getItem("bid_name"), localStorage.getItem("ActivityName") + "竞价");
    bid_array[activity_bid_number]["status"] = "已结束";
    localStorage.setItem(localStorage.getItem("ActivityName") + "竞价", JSON.stringify(bid_array));
}

Bid.BidPriceIndexSearch = function (bid_price_array, price) {
    var index = _.chain(bid_price_array)
        .pluck("price")
        .indexOf(parseInt(price))
        .value()
    return index
}

Bid.BidPriceClassify = function (bid_info_array) {
    var bid_price_array_new = _.chain(bid_info_array)
        .pluck("price")
        .value()
    bid_price_array_new = _.countBy(bid_price_array_new)
    bid_price_array_new = _.pairs(bid_price_array_new)
    bid_price_array_new = _.map(bid_price_array_new, function (array) {
        return _.object(["price", "number"], array)
    })
    return bid_price_array_new;
}

Bid.BidPriceResultIndex = function (bid_price_array) {
    var classified_bid_price_array = Bid.BidPriceClassify(bid_price_array);
    classified_bid_price_array = _.chain(classified_bid_price_array)
        .where({"number": 1})
        .min(function (ob) {
            return ob.price
        })
        .value()
    return Bid.BidPriceIndexSearch(bid_price_array, classified_bid_price_array.price);
}