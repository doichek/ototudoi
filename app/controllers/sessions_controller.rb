class SessionsController < ApplicationController
  def new
    
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    if login(email, password)
      flash[:success] = 'ログインに成功しました。'
      redirect_to topics_url
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end
  
  def create_guest
    user = User.find_by(email: 'guest@yahoo.co.jp')
    session[:user_id] = user.id
    flash[:success] = 'ゲストユーザーでログインしました'
    redirect_to topics_url(user)
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
  private

  def login(email, password)
    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      return true
    else
      return false
    end
  end
  
  
end
