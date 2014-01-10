var myModule = angular.module('myApp', ['mobile-navigate']);
//
//myModule.config(function($routeProvider) {
//    $routeProvider.when("/",{
//        templateUrl:"activity_enroll.html",
//        controller:ActivityEnrollController
//    })
//
//    //routing generate
//    //routing generated over
//});
myModule.run(function ($route, $http, $templateCache) {
    angular.forEach($route.routes, function (r) {
        if (r.templateUrl) {
            $http.get(r.templateUrl, {cache: $templateCache});
        }
    });
});

myModule.controller('MainCtrl', function ($scope, $navigate) {
    $scope.$navigate = $navigate;
});

myModule.directive('ngTap', function () {
    var isTouchDevice = !!("ontouchstart" in window);
    return function (scope, elm, attrs) {
        if (isTouchDevice) {
            var tapping = false;
            elm.bind('touchstart', function () {
                tapping = true;
            });
            elm.bind('touchmove', function () {
                tapping = true;
            });
            elm.bind('touchend', function () {
                tapping && scope.$apply(attrs.ngTap);
            });
        } else {
            elm.bind('click', function () {
                scope.$apply(attrs.ngTap);
            });
        }
    };
});


var native_access;
$(document).ready(function () {


    native_access = new NativeAccess();


});

Activity.data_refresh=function() {
    var bid_info = document.getElementById("activity_enroll_page");
    if (bid_info) {
        var scope = angular.element(bid_info).scope();
        scope.$apply(function () {
            scope.data_refresh();
        })
    }
}

Bid.data_refresh=function() {
    var bid_info = document.getElementById("bid_sign_up_page");
    if (bid_info) {
        var scope = angular.element(bid_info).scope();
        scope.$apply(function () {
            scope.data_refresh();
        })
    }
}

