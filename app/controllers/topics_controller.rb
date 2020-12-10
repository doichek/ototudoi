class TopicsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  
  def index
    if logged_in?
      @topic = current_user.topics.build  # form_with 用
      @topics = Topic.where(flag: nil).order(id: :desc).page(params[:page])
    else
      @topic = Topic.new  # ログインしていない用(ダミー)
      @topics = Topic.where(flag: nil).order(id: :desc).page(params[:page])
    end
  end
  
  # def search
  #   @topic = current_user.topics.build
  #   if params[:keyword] == 'new'
  #     @topics = Topic.order(id: :desc).page(params[:page])
  #     if params[:name].present?
  #       @topics = Topic.where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
  #       if params[:favorite] == "1"
  #         @topics = current_user.likes.where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
  #       end
  #     else
  #       if params[:favorite] == "1"
  #         @topics = current_user.likes.order(id: :desc).page(params[:page])
  #       end
  #     end
      
  #   else #old
  #     @topics = Topic.order(id: :asc).page(params[:page])
  #     if params[:name].present?
  #       @topics = Topic.where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
  #       if params[:favorite] == "1"
  #         @topics = current_user.likes.where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
  #       end
  #     else
  #       if params[:favorite] == "1"
  #         @topics = current_user.likes.order(id: :asc).page(params[:page])
  #       end
  #     end
  #   end
    
  # end


def search
  if logged_in?
    
    @topic = current_user.topics.build
    
    if params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "0" && params[:tag] == "0"
      return @topics = Topic.where(flag: nil).order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "0" && params[:tag] == "0"
      return @topics = Topic.where(flag: nil).order(id: :asc).page(params[:page])
    end


    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "0" && params[:tag] == "0"
      return @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "0" && params[:tag] == "0"
      return @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
    end
    
    
    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "1" && params[:tag] == "0"
      return @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "1" && params[:tag] == "0"
      return @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
    elsif params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "1" && params[:tag] == "0"
      return @topics = current_user.likes.where(flag: nil).order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "1" && params[:tag] == "0"
      return @topics = current_user.likes.where(flag: nil).order(id: :asc).page(params[:page])
    end
 
    
    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "0")
      return @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "0")
      return @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
    elsif params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "0")
      return @topics = current_user.likes.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "0")
      return @topics = current_user.likes.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
    elsif params[:keyword] == 'new' && !params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "0")
      return @topics = Topic.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && !params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "0")
      return @topics = Topic.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
    elsif params[:keyword] == 'new' && params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "0")
      return @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
    elsif params[:keyword] == 'old' && params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "0")
      return @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
    end
  
  else
    redirect_to login_url
  end
end

 














  def create
    if logged_in?
      @topic = current_user.topics.build(topic_params)
  
      if @topic.save 
        flash[:success] = 'コミュニティを作成しました。'
        redirect_to topics_url
      else
        @topics = Topic.order(id: :desc).page(params[:page])
        flash.now[:danger] = 'コミュニティの作成に失敗しました。'
        render 'toppages/index'
      end
      
    else
    redirect_to login_url
    end
  end

  def destroy
    @topic.destroy
    flash[:success] = 'コミュニティを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def topic_params
    params.require(:topic).permit(:title, :tag)
  end
  
  def correct_user
    @topic = current_user.topics.find_by(id: params[:id])
    unless @topic
      redirect_to root_url
    end
  end  
end
