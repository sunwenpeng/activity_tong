function BidListController($scope, $navigate,$http) {
    $scope.turn_to_activity_enroll_page = function () {
        $navigate.go("/ActivityEnroll");
    }

    $scope.bid_begin_checked = Bid.GetBidBeginChecked();
    if (!$scope.bid_begin_checked) {
        $scope.go_to_bid_sign_up_page = function () {
            Bid.PushNewBid();
            BidInfo.updateInfoWithNoResponse($http);
            Bid.SetBidBeginChecked(true);
            Bid.SetBidCreateChecked(true);
            $navigate.go("/BidSignUp");
        }
    }

    $scope.BidNames = Bid.GetActivityBid(Activity.GetActivityName());

    $scope.bid_name_info = function (bid_name) {
        $navigate.go("/BidSignUp");
        Bid.SetBidName(bid_name);
    }
}