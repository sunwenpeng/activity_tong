class Activity < ActiveRecord::Base
  def self.update_user_activities(params)
    Activity.delete_all(:create_user=> params[:user])
    activities = params[:activity_info]
    if activities != nil
      activities.each do |a|
        activity=Activity.new(:name=>a[:name],:status=>a[:status],:create_user=>a[:user])
        activity.save
      end
    end
  end
end
