function CreateActivityListController($scope, $navigate) {
    $scope.go_to_activity_list = function () {
        $navigate.go('/ActivityList');
    }

    $scope.input_activity_name = "";

    $scope.go_to_activity_enroll = function () {
        $scope.name_repeat_checked = _.some(Activity.GetActivityArray(), function(object){
            return object["name"] == $scope.input_activity_name
        });
        if($scope.input_activity_name != "" && $scope.name_repeat_checked == false){
            Activity.SetUnstartedActivity("yes");
            var input_name= $scope.input_activity_name
            Activity.PushNewActivity(input_name);
            $navigate.go('/ActivityEnroll', 'slide');
        }
    }

//    function activity_check() {
//        if($scope.checked == false){
//
//        }
//    }
};

