class Activity < ActiveRecord::Base
  def self.update_user_activities(params)
    Activity.delete_all(:create_user=> params[:_json][5])
    activities = params[:_json][0]
    activities.each do |a|
      activity=Activity.new(:name=>a[:name],:status=>a[:status],:create_user=>a[:user])
      activity.save
    end
  end
end
