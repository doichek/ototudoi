class MicropostsController < ApplicationController
  before_action :require_user_logged_in #current_user
  before_action :correct_user, only: [:destroy]
  
  def show
    @topic = Topic.find_by(id: params[:id]) 
    @micropost = @topic.microposts.build
    @microposts = @topic.microposts.order(id: :desc).page(params[:page])
  end
  
  def search
    if logged_in?
      @topic = Topic.find_by(id: params[:id]) 
      @micropost = @topic.microposts.build
      if params[:keyword] == 'new'
        @microposts = @topic.microposts.order(id: :desc).page(params[:page])
      else #old
        @microposts = @topic.microposts.order(id: :asc).page(params[:page])
      end
    else
      redirect_to login_url
    end
  end
  
  def create
    if logged_in?
      @topic = Topic.find_by(id: params[:micropost][:topic_id]) 
      @micropost = @topic.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = 'メッセージを投稿しました。'
        redirect_to micropost_url(@micropost.topic_id)#この書き方ではなく別の書き方
      else
        @microposts = current_user.microposts.order(id: :desc).page(params[:page])
        flash.now[:danger] = 'メッセージの投稿に失敗しました。'
        render 'toppages/index'
      end
    else
      redirect_to login_url
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content).merge(user_id: current_user.id)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
  
end