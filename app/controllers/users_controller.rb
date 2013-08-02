class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :destroy, :active]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: [:destroy, :active]

  def show
    @user = User.find(params[:id])
    @reports = @user.reports.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    binding.pry
    if @user.save
      binding.pry
      UserMailer.active_user(@user).deliver
      UserMailer.welcome_email(@user).deliver
      
      redirect_to root_url

      flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def active
    users = User.where("active = ?", false)
    users.each do |user|
      if Digest::MD5.hexdigest(user.email) == params[:active]
        user.active = true
        user.save
      end
    end
    redirect_to root_url
  end
  
  private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end