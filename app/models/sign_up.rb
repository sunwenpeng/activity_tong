class SignUp < ActiveRecord::Base
  def self.update_user_sign_ups(params)
      SignUp.delete_all(:user => params[:user])
      signUps = params[:sign_ups]
      if signUps != nil
        signUps.each do |s|
          signUp= SignUp.new(:name=>s[:enroll_name],:phone=>s[:phone],:activity=>s[:activity],
                             :user=>s[:user])
          signUp.save
        end
      end
  end
end
