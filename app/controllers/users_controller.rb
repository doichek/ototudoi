class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :edit]
  
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
    ##下てすと
    #@topic = @user.topics.build(title: "#{@user.name}のコミュニティ", flag: 1)
    ##
  end
  
  def edit_account
    @user = User.find(params[:id])
  end
  
  def edit_profile
    @user = User.find(params[:id])
  end
  

  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params2)
      flash[:success] = '編集しました'
      redirect_to @user
    else
      flash.now[:danger] = '編集に失敗しました'
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    #下テスト
    @topic = @user.topics.build(title: "#{@user.name}のコミュニティ", flag: 1)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
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
    @user = User.find(params[:id])#カード表示に必要
    # @topic = Topic.find_by(user_id: @user.id, frag: 1)
    @topic = Topic.find_by(user_id: params[:id], flag: 1)#てすと
    @micropost = @topic.microposts.build
    @microposts = @topic.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    #params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def user_params2
    params.require(:user).permit(:content, :sex, :address, :content2, :content3, :content4, :image)
    # params.require(:user).permit(:nickname, :email, :password, :password_confirmation, :image)
  end


end
