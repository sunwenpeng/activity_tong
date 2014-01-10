function BidSignUpController($scope, $navigate,$http) {
    $scope.turn_to_bid_list_page = function () {
        $navigate.go("/BidList");
        Bid.SetBidName(null);
    }

    $scope.end_button_choice = (Bid.GetBidStatus() == "biding" ? true:false) ;

    $scope.end_bid_sign_up = function () {
            var end_bid_sign_up_button_checked = confirm("您确定要结束本次竞价么？");
            if (end_bid_sign_up_button_checked == true) {
                Bid.SetBidBeginChecked(false);
                Bid.SetBidSignUpChecked(true);
                Bid.BidStatusChange();
                Bid.SetBidingName("null")
                BidInfo.updateInfoWithNoResponse($http);
                $navigate.go('/BidResult')
                $scope.end_button_choice = false ;
            }
    }

    $scope.show_more_button = false ;

    $scope.show_more_sign_up_info = function () {
        $scope.BidSignUpPeoples = Bid.GetBidInfoArrayNew() ;
    }

    $scope.data_refresh = function () {
//        if ($scope.show_more_button == false) {
//        var bid_info_array_new = Bid.GetBidInfoArrayNew();
//        $scope.BidSignUpPeoples = bid_info_array_new;
//        Bid.SetBidCollectedInfo(bid_info_array_new);

        $scope.BidSignUpPeoples = Bid.GetUserClassifiedBidUps() ;

        $scope.bid_sign_up_name_and_number = Bid.BidSignUpNameAndNumber();

//            $scope.show_more_button = (Bid.GetBidInfoArrayNew()).length > 1 ? true:false      ;
//        }
        BidInfo.updateInfoWithNoResponse($http);
    }

    $scope.data_refresh();

    $scope.push_data = function(){
        BidInfo.updateInfo($http);
    }
}