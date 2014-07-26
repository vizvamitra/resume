class SessionsController < ApplicationController

  skip_before_action :authorize

  layout 'login'

  # GET /login
  def login
    redirect_to bills_path if session[:user_name]
    @user = User.new
  end

  # POST /login
  def create
    login = params[:user][:login].downcase.gsub(/[^\w\d_]+/, '')
    pass = params[:user][:password]
    @user = User.find_by( login: login )
    if @user and @user.authenticate(pass)
      session[:user_name] = @user[:fio]
      redirect_to bills_path
    else
      redirect_to login_path, alert: 'Неверная пара логин/пароль'
    end
  end

  # GAT /logout
  def destroy
    session[:user_name] = nil
    redirect_to login_path
  end
end
