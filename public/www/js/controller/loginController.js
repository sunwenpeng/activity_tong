function loginController($scope,$navigate,$http){
    $scope.loginCheck= function(){
        $http({
            url: "/user/customer_check",
            dataType: "json",
            method: "POST",
            data: JSON.stringify($scope.person)
        }).success(function(response){
             if(response == false){
                 alert('用户名或密码错误!')
             }
             else{
                localStorage.current_user = ($scope.person).name
                $navigate.go('/ActivityList')
                 localStorage.current_token = response
                 console.log(response)
             }
            }).error(function(error){
                $scope.error = error;
            }).error(function(){
                alert("登录失败!")
            });
    }
}