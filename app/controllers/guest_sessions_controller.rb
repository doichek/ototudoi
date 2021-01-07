class GuestSessionsController < ApplicationController
  
  def create
    user = User.find_by(email: 'guest@yahoo.co.jp')
    log_in(user)
    flash[:success] = 'ゲストユーザーでログインしました'
    redirect_to topics_url(user)
  end
  
  private
  def log_in(user)
    session[:user_id] = user.id
  end
  
end
