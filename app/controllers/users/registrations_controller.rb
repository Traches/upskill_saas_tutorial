class Users::RegistrationsController < Devise::RegistrationsController
  before_action :select_plan, only: :new
  # Extend default Devise gem behavior so that users signing up with
  # a pro account (plan ID 2) save with a stripe subscription. 
  # Otherwise, signup as usual. 
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 2
          resource.save_with_subscription
        else 
          resource.save
        end
      end
    end
  end
  
  
  private
    def select_plan
      # Todo: Update this to look at database IDs, rather than hardcoding valid 
      # plans here. This is how the upskill tutorial did it. 
      unless (params[:plan] == '1' || params[:plan] == '2')
        flash[:notice] = "Please select a membership plan from the home page."
        redirect_to root_path
      end
    end
end