class UsersController < ApplicationController

  def new
    # renders the #form_for helper
    @user = User.new
  end

  def show
    # renders the user profile
    @user = User.find(params[:id])
  end

  def create
    # passing the params[:user] hash to User.new() is a risk, prevented by default in rails
    # @user = User.new(params[:user])

    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      # displayed on the first page after redirect
      flash[:success] = "Welcome to the Sample App!"
      # you can use users_url, users_path or simply @user
      redirect_to user_path(@user)
    else
      render 'new'
    end

  end

  def index

  end

  def edit
    # find the user in the database, render the user profile for editing
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
      # TODO:
    else
      render 'edit'
    end
  end

  def destroy

  end

  private
    def user_params
      # params must have a 'user' hash, with only the following atttributes
      # to is to prevent mass assignment vulnerability
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end
