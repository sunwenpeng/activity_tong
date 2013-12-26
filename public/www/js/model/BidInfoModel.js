function BidInfo(name,phone,price,order){
    this.name = name
    this.phone = phone
    this.price = price
    this.order = order
}

BidInfo.prototype.pro = function(){
    this.price = Number((this.price).trim());
}

BidInfo.updateInfo =function($http){
        $http({
            url: "/phone_customer/customer_data_update",
            dataType: "json",
            method: "POST",
            data: {'activity_info':Activity.GetUserActivityArray(),'sign_ups': Activity.GetUserActivityEnrollInfo(),
                'bids_info':Bid.GetUserBids(),'bid_ups':Bid.GetUserBidUps(),'bid_results':Bid.GetUserBidResults(),
                'user':localStorage.current_user,'token':localStorage.current_token}
        }).success(function(response){
                if(response == 'true'){
                    alert('同步数据成功!')
                }
            }).error(function(){
                alert("同步数据失败!")
            });
}

BidInfo.updateInfoWithNoResponse =function($http){
    $http({
        url: "/phone_customer/customer_data_update",
        dataType: "json",
        method: "POST",
        data: {'activity_info':Activity.GetUserActivityArray(),'sign_ups': Activity.GetUserActivityEnrollInfo(),
            'bids_info':Bid.GetUserBids(),'bid_ups':Bid.GetUserBidUps(),'bid_result':Bid.GetUserBidResults(),
            'current_user':localStorage.current_user,'token':localStorage.current_token}
    })
}