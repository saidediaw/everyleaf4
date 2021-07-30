class Admin::UsersController < ApplicationController
  # skip_before_action :authenticate_user, only: [:edit, :update, :destroy, :show]
	before_action :admin
	before_action :set_user, only: [:edit, :update, :destroy, :show]
	def index
		@users = User.select(:id, :name, :admin)
	end
	def new
		@user = User.new
	end
	def create
		@user = User.new(user_params)
		if @user.save
		  	redirect_to admin_users_path
		else
		  	render :new
		end
	end
	def edit
	end
	def update
		if params[:admin]
			if @user.admin == true
				@user.update_attribute(:admin, false)
			else
				@user.update_attribute(:admin, true)
			end
		else
			if @user.update(user_params)
			    redirect_to admin_users_path, notice: "Profil has been updated!"
			else
			    render :edit
			end
		end
	end
	def show
    # @tasks= Task.all
	end
  def destroy
		user = User.find(params[:id])
		if (current_user == user) && (current_user.admin?)
			redirect_to admin_users_path, notice: "You cannot delete own admin account!"
		elsif @user.destroy
			redirect_to admin_users_path, notice: "user deleted!"
		else
			redirect_to admin_users_path, notice: "user not deleted!"
        end
	end
	private
	def user_params
		params.require(:user).permit(:name, :email, :password,
	                          	 :password_confirmation, :admin)
	end
	def set_user
		@user = User.find(params[:id])
	end
	def admin
		if current_user.admin == false || current_user.admin.blank?
			redirect_to tasks_path, notice:"Only administrators can access this page!!"
		end
	end

  def authenticate_user
    if @current_user == nil
      flash[:notice] = t('notice.login_needed')
      redirect_to new_session_path
    end
  end
end
