class UsersController < ApplicationController
  before_action :authenticate_user!
  
  # GET to /users/:id
  def show
    @user = User.find(params[:id])  
  end
  
  # GET to /users
  def index
    # Includes is important. It stops you from querying the database repeatedly. 
    @users = User.includes(:profile)
  end
end