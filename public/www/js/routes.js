myModule.config(function ($routeProvider) {
    $routeProvider.when("/", {
        templateUrl: "pages/login.html",
        controller: loginController
    }).when("/ActivityList", {
            templateUrl: "pages/activity_list.html",
            controller: ActivityListController
        }).when("/CreateActivityList", {
            templateUrl: "pages/create_activity_list.html",
            controller: CreateActivityListController
        }).when("/ActivityEnroll", {
            templateUrl: "pages/activity_enroll.html",
            controller: ActivityEnrollController
        }).when("/BidList", {
            templateUrl: "pages/bid_list.html",
            controller: BidListController
        }).when("/BidSignUp", {
            templateUrl: "pages/bid_sign_up.html",
            controller: BidSignUpController
        }).when("/BidResult", {
            templateUrl: "pages/bid_result.html",
            controller: BidResultController
        }).when("/BidAnalysis", {
            templateUrl: "pages/bid_analysis.html",
            controller: BidAnalysisController
        })
        .otherwise({
            redirectTo: "/ActivityList"
        });

    //routing generate
    //routing generated over
});

/** Here is example
 myModule.config(function($routeProvider) {
    $routeProvider.when("/", {
        templateUrl: "pages/activity_list_page.html",
        controller: ActivityListController
    }).when("/activity/create", {
            templateUrl: "pages/activity_create_page.html",
            controller: ActivityCreateController
        }).when("/sign_ups/list/:activity_name", {
            templateUrl: "pages/apply_page.html",
            controller: SignUpListController
        }).otherwise({
            redirectTo: "/"
        });
});
 **/