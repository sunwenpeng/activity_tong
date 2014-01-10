function loginController($scope,$navigate,$http){
//    if(localStorage.current_user){
//       $navigate.go('/ActivityList')
//    }
    $scope.loginCheck= function(){
        $http({
            url: "/phone_customer/customer_check",
            dataType: "json",
            method: "POST",
            data: JSON.stringify($scope.person)
        }).success(function(response){
             if(response == 'false'){
                 return alert('用户名或密码错误!')
             }
            localStorage.current_user = ($scope.person).name
            $navigate.go('/ActivityList')
             localStorage.current_token = response
            }).error(function(error){
                $scope.error = error;
            }).error(function(){
                alert("登录失败!")
            });
    }
}