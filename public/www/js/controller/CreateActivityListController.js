function CreateActivityListController($scope, $navigate) {
    $scope.go_to_activity_list = function () {
        $navigate.go('/ActivityList');
    }

    $scope.input_activity_name = "";

    $scope.go_to_activity_enroll = function () {
        if ($scope.input_activity_name != "")
            activity_check()

        function activity_check() {
            $scope.checked = _.some(Activity.GetActivityArray(), function (object) {
                return object["name"] == $scope.input_activity_name
            });
            if($scope.checked == false){
                Activity.SetUnstartedActivity("yes");
                $navigate.go('/ActivityEnroll');
                Activity.PushNewActivity($scope.input_activity_name);
            }
        }
    }
};
