function ActivityEnrollController($scope, $navigate,$http) {
    $scope.go_to_activity_list = function () {
        $navigate.go('/ActivityList');
    }
    var activity_index = Activity.ActivitySearch(Activity.GetActivityArray(), Activity.GetActivityName());

    $scope.begin = function () {
        Activity.ActivityEnrollBegin();
        Activity.ActivityStatusChange(activity_index, "started_and_unended");
        $scope.activity_status = "started_and_unended";
    }

    $scope.end = function () {
        var confirm_checked = confirm("确定要结束本活动报名么？");
        if (confirm_checked == true) {
            Activity.ActivityStatusChange(activity_index, "已结束")
            Activity.ActivityEnrollEnd() ;
            $navigate.go('/BidList');
        }
    }

    $scope.data_init = function () {
        $scope.activity_status = Activity.GetActivityArray()[activity_index]["status"];

        $scope.EnrollingActivities = Activity.GetActivityEnrollInfo(Activity.GetActivityName());

        $scope.enroll_number = Activity.ActivityEnrollNumber();

        BidInfo.updateInfoWithNoResponse($http);
    }

    $scope.data_init();

    $scope.go_bid_list_page = function () {
        $navigate.go("/BidList");
    }
};