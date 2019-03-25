class UsersController < ApplicationController
  before_action :find_user, except: [:index, :new, :create]
  before_action :authenticate_user!

  # authorized by admin
  def index
    @users =   User.unscoped
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user].permit!)
    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = I18n.t('notice_successful_delete')
    redirect_back fallback_location: root_path
  end

  # authorized by manage roles
  def show
  end

  def change_password
    if params[:user][:password] == params[:user][:password_confirmation]
      if @user.update(password: params[:user][:password])
        flash[:notice] = I18n.t('devise.passwords.updated_not_active')
      else
        flash[:error] = @user.errors.full_messages.join('<br/>')
      end

    else
      flash[:error] = 'Password not matched'
    end
    redirect_to user_path(@user)
  end

  private

  def find_user
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize
    render_403 unless User.current.admin?
  end
end
