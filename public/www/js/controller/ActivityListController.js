function ActivityListController($scope,$navigate,$http){
    $scope.activity_create_button_checked = (Activity.GetEnrollingActivityName() != "" ? true : false);

    $scope.go_to_create_activity_list=function(){
        if($scope.activity_create_button_checked == false){
           $navigate.go('/CreateActivityList');
        }
    }

    $scope.go_to_activity_enroll_list=function(activity_name){
        $navigate.go('/ActivityEnroll');
        Activity.SetActivityName(activity_name) ;
    }

    $scope.activities=Activity.GetUserActivityArray();
//    $scope.push_data = function(){
//        $http({
//            url: "/activity/customer_data_update",
//            dataType: "json",
//            method: "POST",
//            data: [Activity.GetUserActivityArray(), Activity.GetUserActivityEnrollInfo(),Bid.GetUserBids(),Bid.GetUserBidUps(),Bid.GetUserBidResults()]
//        }).success(function(response){
//                if(JSON.parse(response) == true){
//                    alert('同步数据成功!')
//                }
//            }).error(function(error){
//                $scope.error = error;
//            }).error(function(){
//                alert("同步数据失败!")
//            });
//    }
    $scope.push_data = function(){
        BidInfo.updateInfo($http);
    }
};