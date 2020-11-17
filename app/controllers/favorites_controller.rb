class FavoritesController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    current_user.favorite(@topic)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    current_user.unfavorite(@topic)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end
