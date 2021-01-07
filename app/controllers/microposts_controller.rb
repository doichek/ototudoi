class MicropostsController < ApplicationController
  before_action :require_user_logged_in, only: [:create]
  before_action :correct_user_destroy, only: [:destroy]
  
  def show
    @topic = Topic.find_by(id: params[:id]) 
    @micropost = @topic.microposts.build
    @microposts = @topic.microposts.order(id: :desc).page(params[:page])
    render 'microposts/show&search'
  end
  
  def search
    @topic = Topic.find_by(id: params[:id]) 
    @micropost = @topic.microposts.build
    if params[:keyword] == 'new'
      @microposts = @topic.microposts.order(id: :desc).page(params[:page])
    else #old
      @microposts = @topic.microposts.order(id: :asc).page(params[:page])
    end
    render 'microposts/show&search'
  end
  
  def create
    @topic = Topic.find_by(id: params[:micropost][:topic_id]) 
    @micropost = @topic.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = '投稿しました。'
      redirect_to micropost_url(@micropost.topic_id)
    else 
      #render処理をするとurlが変わってしまいその影響で再度createするとエラーになってしまう(原因不明どうにかしたい)
      # @microposts = @topic.microposts.order(id: :desc).page(params[:page])
      # flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      # render 'microposts/show&search'
      flash[:danger] = '投稿に失敗しました。'
      redirect_to micropost_url(@micropost.topic_id)
    end
  end

  def destroy
    @micropost.update(delete_frag: 1)
    if @micropost.save
      flash[:success] = '投稿を削除しました。'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = '投稿の削除に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content,:image,:youtube_url).merge(user_id: current_user.id)
  end

  def correct_user_destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
  
end