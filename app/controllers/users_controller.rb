class UsersController < ApplicationController
  def new
  end

  def create
    render plain: params[:user].inspect
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
  end
end
