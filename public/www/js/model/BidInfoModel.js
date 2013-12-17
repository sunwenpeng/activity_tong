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
            url: "/activity/customer_data_update",
            dataType: "json",
            method: "POST",
            data: [Activity.GetUserActivityArray(), Activity.GetUserActivityEnrollInfo(),Bid.GetUserBids(),Bid.GetUserBidUps(),Bid.GetUserBidResults(),localStorage.current_user]
        }).success(function(response){
                if(JSON.parse(response) == true){
                    alert('同步数据成功!')
                }
            }).error(function(){
                alert("同步数据失败!")
            });
}