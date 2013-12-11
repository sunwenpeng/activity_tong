function BidAnalysisController($scope,$navigate){
    $scope.return_to_bid_list_page= function(){
        $navigate.go('/BidList')
    }

    $scope.return_to_bid_result_page=function(){
        $navigate.go('/BidResult')
    }

    $scope.bid_sign_up_name_and_number = Bid.BidSignUpNameAndNumber() ;

    $scope.bid_analysis_infos = Bid.GetBidCollectedInfo();

    $scope.bid_success_person_info = Bid.BidSuccessPersonInfo() ;
}