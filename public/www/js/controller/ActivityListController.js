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

    $scope.push_data = function(){
        BidInfo.updateInfo($http);
    }
};