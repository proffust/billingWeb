class UsersController < ApplicationController
  before_action :authenticate_auth_user! , except: [:info]
  MTik::verbose=false
  def new
    @user = User.new
  end

  def create
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS)
    @user = User.new(users_params)
    @user.access_state = true
    if @user.save
      tik.get_reply(
      '/ip/firewall/address-list/add',
      "=address=#{@user.address}",
      "=list=#{@user.is_router ? "User_Router" : "users_new" }",
      "=comment=#{@user.name}") do |request, sentence|
        @trap = request.reply.find_sentence('!trap')
        if @trap.nil?
          tik.get_reply(
          '/queue/simple/add',
          "=max-limit=#{@user.is_router ? "40M/40M" : "20M/20M"}",
          "=name=#{@user.name}",
          "=target=#{@user.address}",
          "=queue=default/default",
          "=total-queue=default") do |request, sentence|
            @trap = request.reply.find_sentence('!trap')
            if @trap.nil?
              tik.close
              redirect_to action: "index"
            else
              @user.destroy
              render 'new'
            end
          end
        end
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    old_address = user.address
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS)
    if user.update(users_params)
      tik.get_reply('/ip/firewall/address-list/set',
                    "=address=#{user.address}",
                    "=list=#{user.is_router ? "User_Router" : "users_new" }",
                    "=comment=#{user.name}",
                    "=.id=#{tik.get_reply('/ip/firewall/address-list/print',
                                               ".proplist=.id",
                                               "?address=#{old_address}")[0]['.id']}") do |request, sentence|
        @trap = request.reply.find_sentence('!trap')
        if @trap.nil?
          tik.get_reply('/queue/simple/set',
                        "=target=#{user.address}",
                        "=name=#{user.name}",
                        "=max-limit=#{user.is_router ? "40M/40M" : "20M/20M"}",
                        "=.id=#{tik.get_reply('/queue/simple/print',
                                                   ".proplist=.id",
                                                   "?target=#{old_address}/32")[0]['.id']}") do |request, sentence|
            @trap = request.reply.find_sentence('!trap')
            if @trap.nil?
              tik.close
              redirect_to action: "index"
            else
              render 'edit'
            end
          end
        else
          render 'edit'
        end
      end
    else
      render 'edit'
    end
  end

  def index
    if Rails.env.production?
      @users = User.find_by_sql("select * from users ORDER BY inet_aton(address)")
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def extend
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS)
    user = User.find(params[:id])
    user.date_of_disconnect = user.date_of_disconnect + 1.month
    if Date.today < user.date_of_disconnect
      user.access_state = true
    end
    user.update(update_params)
    tik.get_reply('/ip/firewall/address-list/set',
                  "=disabled=#{user.access_state ? "no" : "yes" }",
                  "=.id=#{tik.get_reply('/ip/firewall/address-list/print',
                                             ".proplist=.id",
                                             "?address=#{user.address}")[0]['.id']}")
    tik.close
    redirect_to action: "index"
  end

  def deactivate
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS, :use_ssl => false)
    user = User.find(params[:id])
    user.access_state = false
    user.update(update_params)
    tik.get_reply('/ip/firewall/address-list/set',
                  "=disabled=yes",
                  "=.id=#{tik.get_reply('/ip/firewall/address-list/print',
                                             ".proplist=.id",
                                             "?address=#{user.address}")[0]['.id']}")
    tik.close
    redirect_to action: "index"
  end

  def activate
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS)
    user = User.find(params[:id])
    user.access_state = true
    user.update(update_params)
    tik.get_reply('/ip/firewall/address-list/set',
                  "=disabled=no",
                  "=.id=#{tik.get_reply('/ip/firewall/address-list/print',
                                             ".proplist=.id",
                                             "?address=#{user.address}")[0]['.id']}")
    tik.close
    redirect_to action: "index"
  end

  def destroy
    tik = MTik::Connection.new(:host => M_HOST, :user => M_USER, :pass => M_PASS)
    user = User.find(params[:id])
    tik.get_reply('/ip/firewall/address-list/remove',
                  "=.id=#{tik.get_reply('/ip/firewall/address-list/print',
                                             ".proplist=.id",
                                             "?address=#{user.address}")[0]['.id']}")
    tik.get_reply('/queue/simple/remove',
                  "=.id=#{tik.get_reply('/queue/simple/print',
                                             ".proplist=.id",
                                             "?target=#{user.address}/32")[0]['.id']}")
    user.destroy
    tik.close
    redirect_to action: "index"
  end

  def info
    @ipaddress = request.env['HTTP_X_FORWARDED_FOR']
    @user=User.find_by(address: @ipaddress)
  end

  private
    def users_params
      params.require(:user).permit(:name, :address, :is_router, :date_of_disconnect, :access_state)
    end

    def update_params
      params.permit(:name, :address, :is_router, :date_of_disconnect, :access_state, :updated_at)
    end
end
