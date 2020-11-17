class MicropostsController < ApplicationController
  before_action :require_user_logged_in #current_user
  before_action :correct_user, only: [:destroy]
  
  def show
    @topic = Topic.find_by(id: params[:id]) 
    @micropost = @topic.microposts.build
    @microposts = @topic.microposts.order(id: :desc).page(params[:page])
  end
  
  def create
    @topic = Topic.find_by(id: params[:micropost][:topic_id]) 
    @micropost = @topic.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
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