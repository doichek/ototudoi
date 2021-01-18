class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :edit_profile,  :edit_account, :posts, :search,]
  before_action :correct_user, only: [:edit_account, :edit_profile]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def edit_account
    @user = User.find(params[:id])
  end
  
  def edit_profile
    @user = User.find(params[:id])
  end
  
  def update
    @path = Rails.application.routes.recognize_path(request.referer)
    @user = User.find(params[:id])
    #アカウント変更
    if @path[:action] == "edit_account"
      if @user.update(user_params)
        flash[:success] = '登録内容を変更しました'
        redirect_to @user
      else
        flash.now[:danger] = '登録内容の変更に失敗しました'
        render :edit_account
      end
    #プロフィール編集
    else
      if @user.update(user_params2)
        flash[:success] = '編集しました'
        redirect_to @user
      else
        flash.now[:danger] = '編集に失敗しました'
        render :edit_profile
      end
    end
  end

  def create
    @path = Rails.application.routes.recognize_path(request.referer)
    #個人コミュニティからの投稿
    if (@path[:action] == "posts") or (@path[:action] == "search")
      @topic = Topic.find_by(user_id: params[:id], flag: 1)
      @micropost = @topic.microposts.build(micropost_params)
      @path = Rails.application.routes.recognize_path(request.referer)
      if @micropost.save
        flash[:success] = 'メッセージを投稿しました。'
        redirect_to posts_user_url(@topic.user_id)
      else
        #render処理をするとurlが変わってしまいその影響で再度createするとエラーになってしまう(原因不明どうにかしたい)
        # @microposts = @topic.microposts.order(id: :desc).page(params[:page])
        # @user = User.find(params[:id])#card表示に必要
        # flash.now[:danger] = 'メッセージの投稿に失敗しました。'
        # render 'users/posts&search'
        flash[:danger] = 'メッセージの投稿に失敗しました。'
        redirect_to posts_user_url(@topic.user_id)
      end
    #アカウントの登録
    else
      @user = User.new(user_params)
      @user.topics.build(title: "#{@user.name}のコミュニティ", flag: 1)
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = 'ユーザを登録し、ログインしました。'
        redirect_to topics_url
      else
        flash.now[:danger] = 'ユーザの登録に失敗しました。'
        render :new
      end
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def posts
    @user = User.find(params[:id])#card表示に必要
    @topic = Topic.find_by(user_id: params[:id], flag: 1)
    @micropost = @topic.microposts.build
    counts(@user)
    @microposts = @topic.microposts.order(id: :desc).page(params[:page])
    render "posts&search"
  end
  
  def search
    @user = User.find(params[:id])#card表示に必要
    @topic = Topic.find_by(user_id: params[:id], flag: 1)
    @micropost = @topic.microposts.build
    if params[:keyword] == 'new'
      @microposts = @topic.microposts.order(id: :desc).page(params[:page])
    else #old
      @microposts = @topic.microposts.order(id: :asc).page(params[:page])
    end
    render "posts&search"
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def user_params2
    params.require(:user).permit(:content, :sex, :age, :address, :content2, :content3, :content4, :image)
  end

  def micropost_params
    params.require(:micropost).permit(:content,:image,:youtube_url).merge(user_id: current_user.id)
  end

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
