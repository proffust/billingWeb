class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(users_params)
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

  private
    def users_params
      params.require(:user).permit(:name, :address, :is_router, :date_of_disconnect)
    end
end
