class ProfilesController < ApplicationController
  
  # GET to /users/:user_id/profile/new
  def new
    # Render blank profile details form  
    @profile = Profile.new
  end
  
  # POST request to /users/:user_id/profile
  def create
    # Ensure that we have the right user
    @user = User.find( params[:user_id] )
    # Create profile linked to this specific user
    @profile = @user.build_profile( profile_params )
    @profile.save
    if @profile.save
      flash[:success] = "Profile updated!"
      # TODO: Redirect to profile page, once there is one. 
      redirect_to user_path(params[:user_id])
    else
      # TODO: don't dump the user's inputs if save to database fails. 
      render action: :new
    end
  end
  # GET request to /users/:user_id/profile/edit
  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile
    
  end
  # PUT and PATCH requests to /users/:user_id/profile
  def update
    # Retrieve user from the database
    @user = User.find(id: params[:user_id])
    # Assign user profile to an instance variable
    @profile = @user.profile
    # Mass assign edited profile attributes and save. 
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile updated!"
      # Redirect to profile page. 
      redirect_to user_path(id: params[:user_id])
    else
      # TODO: don't dump the user's inputs if save to database fails. 
      render action: :edit
    end
  end

  private
    def profile_params
      params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
    end
  
  
end