class NatsController < ApplicationController
  before_action :authenticate_auth_user!
  MTik::verbose=true
  def new
    @nat = Nat.new
  end

  def create
    tik = MTik::Connection.new(:host => '10.11.10.217', :user => 'admin', :pass => 'password')
    @nat = Nat.new(nats_params)
    @nat.state = true
    @nat.owner = current_auth_user.id
    if @nat.save
      tik.get_reply(
      '/ip/firewall/nat/add',
      "=chain=dstnat",
      "=action=netmap",
      "=to-addresses=#{@nat.int_ip}",
      "=to-ports=#{@nat.int_port}",
      "=protocol=tcp",
      "=in-interface=ether2",
      "=dst-port=#{@nat.ext_port}",
      "=comment=#{@nat.name}_#{Nat.last['id']}") do |request, sentence|
        @trap = request.reply.find_sentence('!trap')
        if @trap.nil?
          redirect_to action: "index"
        else
          @nat.destroy
          render 'new'
        end
      end
    else
      render 'new'
    end
    tik.close
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
    tik = MTik::Connection.new(:host => '10.11.10.217', :user => 'admin', :pass => 'password')
    nat = Nat.find(params[:id])
    tik.get_reply('/ip/firewall/nat/remove',
    "=.id=#{tik.get_reply('/ip/firewall/nat/print',
                          ".proplist=.id","?comment=#{nat.name}_#{nat.id}")[0]['.id']}")
    nat.destroy
    redirect_to action: "index"
    tik.close
  end

  private
    def nats_params
      params.require(:nat).permit(:name, :ext_port, :int_port, :int_ip)
    end
    def update_params
      params.permit(:name, :ext_port, :int_port, :int_ip)
    end
end
