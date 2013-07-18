class UsersController < ApplicationController
  before_filter :ensure_not_guest, except: [:new, :create]
  before_filter :authorize_user_or_admin, only: [:show]
  before_filter :authorize_admin, only: [:index]
  before_filter :authorize_user, except: [:new, :create, :show, :index]

  def show
    @user = UserPresenter.new User.find(params[:id])
  end

  def index
    @users = UserPresenter.new_from_array User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Update successfull"
    else
      flash[:errors] = 'Something went wrong'
      render :edit
    end
  end

  def new
    @user = User.new
  end

  def destroy
    @user = User.find(params[:id])

    if @user.delete
      redirect_to users_path, notice: "Deletion succeeded"
    else
      redirect_to users_path, notice: "Deletion succeeded"
      flash[:errors] = "Something went wrong"
    end
  end

  def create
    @user = User.new(params[:user])
    binding.pry

    if @user.save
      # UserRegistration.registration_confirmation(@user).deliver
      redirect_to new_session_path, notice: 'Successfully signed up'
    else
      flash[:errors] = "Something went wrong"
      render "new"
    end
  end

  def confirmation
    user = User.where(email: params[:email]).first
    if params[:key] == BCrypt::Password.create(user.email)
      user.activated = true
      user.save
      flash[:notice] = "Registration is finished"
      redirect_to user_path(user)
    else
      flash[:errors] = "Your key is wrong"
      redirect_to products_path
    end
  end
end