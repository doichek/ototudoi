class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def correct_user#他のユーザのアカウント変更画面等にアクセスできなくする
    if current_user.id != params[:id].to_i
      redirect_to root_url
    end
  end
  
  
  def counts(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
  end
end