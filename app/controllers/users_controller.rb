class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(users_params)
    @user.access_state = true;
    @user.save
    redirect_to @user
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def deactivate
    @user = User.find(params[:id])
    @user.access_state = false;
    @user.update
    #redirect_to @user
  end

  def activate
    @user = User.find(params[:id])
    @user.access_state = true;
    @user.update!(users_params)
    #redirect_to @user
  end


  private
    def users_params
      params.require(:user).permit(:name, :address, :is_router, :date_of_disconnect, :access_state)
    end
end
