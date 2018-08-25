class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def_param_group :user do
    param :user, Hash, required: true, action_aware: true do
      param :email, String, "Email of the user", required: true
    end
  end

  api :GET, "/users/", "List users"
  def index
    @users = paginate User.all
    render json: UserSerializer.new(@users)
  end

  api :GET, "/users/:id", "Show user"
  def show
    render json: UserSerializer.new(@user)
  end

  api :POST, "/users/", "Create user"
  param_group :user
  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user), status: :created, location: [:api, :v1, @user]
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/users/:id", "Update user"
  param_group :user
  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/users/:id", "Delete user"
  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
