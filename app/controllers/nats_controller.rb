class NatsController < ApplicationController
  before_action :authenticate_auth_user!
  def new
    @nat = Nat.new
  end

  def create
    @nat = Nat.new(nats_params)
    @nat.state = true
    @nat.owner = current_auth_user.id
    if @nat.save
      redirect_to action: "index"
    else
      render 'new'
    end
  end

  def edit
    @nat = Nat.find(params[:id])
  end

  def update
    nat = Nat.find(params[:id])
    if nat.update(nats_params)
      redirect_to action: "index"
    else
      render 'edit'
  end

  def show
    @nat = Nat.find(params[:id])
  end

  def index
    @nats = Nat.all
  end

  def activate
    nat = Nat.find(params[:id])
    nat.state = true
    nat.update(update_params)
    redirect_to action: "index"
  end

  def deactivate
    nat = Nat.find(params[:id])
    nat.state = false
    nat.update(update_params)
    redirect_to action: "index"
  end

  def destroy
    nat = Nat.find(params[:id])
    nat.destroy
    redirect_to action: "index"
  end

  private
    def nats_params
      params.require(:nat).permit(:name, :ext_port, :int_port, :int_ip)
    end
    def update_params
      params.permit(:name, :ext_port, :int_port, :int_ip)
    end
end
