function BidResultController($scope, $navigate) {
    $scope.return_to_bid_list_page = function () {
        $navigate.go('/BidList')
    }

    $scope.go_to_bid_analysis_page = function () {
        $navigate.go('/BidAnalysis')
    }

    $scope.bid_sign_up_name_and_number = Bid.BidSignUpNameAndNumber() ;
    var bid_info_array_new = Bid.GetBidInfoArrayNew();
    Bid.SetBidSuccessPersonInfo() ;

    $scope.BidSignUpPeoples = bid_info_array_new;
    Bid.SetBidCollectedInfo(bid_info_array_new);

    $scope.bid_success_person_info = Bid.BidSuccessPersonInfo() ;

    $scope.result = Bid.GetBidSuccessPersonInfo()  ;

    $scope.bid_result_pop_out = JSON.stringify(Bid.GetBidSuccessPersonInfo()) == JSON.stringify([]) ? false : true ;
    $scope.shut_down_the_result_pop_out = function () {
        $scope.bid_result_pop_out = undefined ;
    }

    setTimeout(function(){
        $scope.$apply(function(){
            $scope.bid_result_pop_out = undefined;
        });
    }, 3000);
}