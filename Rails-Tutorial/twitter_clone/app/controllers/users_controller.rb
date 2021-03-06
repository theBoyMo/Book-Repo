class UsersController < ApplicationController

  # `before filter` - ensure that users are logged in before they can
  # execute the following actions, by default before_filter applies to every action
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]

  # ensure that the current user can only edit/update their own profile
  before_action :correct_user, only: [:edit, :update]

  # ensure that only admins can delete users
  before_action :admin_user, only: :destroy


  def index
    # return users a page ata time, 30 records by default
    # @users = User.paginate(page: params[:page])

    # list only users whose accounts have been activated
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    # renders the user profile if account activated
    @user = User.find_by(id: params[:id])
    # render the users microposts on their profile page
    @microposts = @user.microposts.paginate(page: params[:page])
    # stops you seeing the account of users who aren't activated
    redirect_to root_path and return unless @user.activated?
  end

  def new
    # renders the #form_for helper
    @user = User.new
  end

  def create
    # passing the params[:user] hash to User.new() is a risk, prevented by default in rails
    # @user = User.new(params[:user])

    @user = User.new(user_params)
    if @user.save
      # log_in(@user)
      @user.send_activation_email
      # displayed on the first page after redirect
      flash[:success] = "Please check your email to activate your account."
      # you can use users_url, users_path or simply @user
      redirect_to root_path
    else
      render 'new'
    end

  end

  def edit
    # find the user in the database, render the user profile for editing
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user  = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
    def user_params
      # params must have a 'user' hash, with only the following atttributes
      # to is to prevent mass assignment vulnerability
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      user = User.find_by(id: params[:id])
      if !current_user?(user)
        flash[:danger] = 'You are not authorised to view that page'
        redirect_to root_path
        return false
      end
      return true
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
