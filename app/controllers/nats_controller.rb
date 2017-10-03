class NatsController < ApplicationController
  def new
  end

  def create
    nat = Nat.new(nats_params)
    nat.state = true;
    nat.owner = 1;
    nat.save
    redirect_to action: "index"
  end

  def edit
    @nat = Nat.find(params[:id])
  end

  def update
    nat = Nat.find(params[:id])
    nat.update(nats_params)
    redirect_to action: "index"
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

  private
    def nats_params
      params.require(:nat).permit(:name, :ext_port, :int_port, :int_ip)
    end
    def update_params
      params.permit(:name, :ext_port, :int_port, :int_ip)
    end
end
