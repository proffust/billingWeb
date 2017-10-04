class UsersController < ApplicationController
  before_action :authenticate_auth_user!
  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    @user.access_state = true
    if @user.save
    redirect_to action: "index"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(users_params)
    redirect_to action: "index"
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def extend
    user = User.find(params[:id])
    user.date_of_disconnect = user.date_of_disconnect + 1.month
    user.update(update_params)
    redirect_to action: "index"
  end

  def deactivate
    user = User.find(params[:id])
    user.access_state = false
    user.update(update_params)
    redirect_to action: "index"
  end

  def activate
    user = User.find(params[:id])
    user.access_state = true
    user.update!(update_params)
    redirect_to action: "index"
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to action: "index"
  end

  private
    def users_params
      params.require(:user).permit(:name, :address, :is_router, :date_of_disconnect, :access_state)
    end

    def update_params
      params.permit(:name, :address, :is_router, :date_of_disconnect, :access_state, :updated_at)
    end
end
