class TopicsController < ApplicationController
  before_action :require_user_logged_in, only: [:create]
  before_action :correct_user_destroy, only: [:destroy]

  def index
    if logged_in?
      @topic = current_user.topics.build  # form_with用
    else
      @topic = Topic.new  # form_with用(未ログイン時のダミー)
    end
    @topics = Topic.where(flag: nil).order(id: :desc).page(params[:page])
    render "topics/index&search"
  end
  
  def search
    if logged_in?
      @topic = current_user.topics.build  # form_with用
    else
      @topic = Topic.new  # form_with用(未ログイン時のダミー)
    end
  
    if params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "0" && params[:tag] == "99"
      @topics = Topic.where(flag: nil).order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "0" && params[:tag] == "99"
      @topics = Topic.where(flag: nil).order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    end

    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "0" && params[:tag] == "99"
      @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "0" && params[:tag] == "99"
      @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    end
    
    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "1" && params[:tag] == "99"
      @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "1" && params[:tag] == "99"
      @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "1" && params[:tag] == "99"
      @topics = current_user.likes.where(flag: nil).order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "1" && params[:tag] == "99"
      @topics = current_user.likes.where(flag: nil).order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    end
 
    if params[:keyword] == 'new' && params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "99")
      @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "99")
      @topics = current_user.likes.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'new' && !params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "99")
      @topics = current_user.likes.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && !params[:name].present? && params[:favorite] == "1" && !(params[:tag] == "99")
      @topics = current_user.likes.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'new' && !params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "99")
      @topics = Topic.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && !params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "99")
      @topics = Topic.where(flag: nil).where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'new' && params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "99")
      @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :desc).page(params[:page])
      render "topics/index&search" and return
    elsif params[:keyword] == 'old' && params[:name].present? && !(params[:favorite] == "1") && !(params[:tag] == "99")
      @topics = Topic.where(flag: nil).where('title LIKE ?', "%#{params[:name]}%").where(tag: "#{params[:tag]}").order(id: :asc).page(params[:page])
      render "topics/index&search" and return
    end
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save 
      flash[:success] = 'コミュニティを作成しました。'
      redirect_to topics_url
    else
      @topics = Topic.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'コミュニティの作成に失敗しました。'
      render 'topics/index'
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
  
  def correct_user_destroy
    @topic = current_user.topics.find_by(id: params[:id])
    unless @topic
      redirect_to root_url
    end
  end  
  
end
