class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:index, :destroy]
	skip_before_action :logged_in_user, only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users_selected_in_nav = true
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if (@user.email != current_user.email && !current_user.admin?)
      flash[:danger] = "You are not authorized to see other users information."
      redirect_to current_user
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !current_user.is_admin? && (@user.email != current_user.email)
      flash[:warning] = "A user can only modify their own data."
      redirect_to @user
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
			if @user.save
				log_in @user unless logged_in?
        flash[:success] = "User was successfully created."
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:danger] = "There was an error performing the operation. #{@user.errors.full_messages.first}"
        format.html { redirect_back fallback_location: users_path}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "User information was successfully updated."
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        flash[:danger] = "There was an error performing the operation. #{@user.errors.full_messages.first}"
        format.html { redirect_back fallback_location: @user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:success] = "User was successfully deleted."
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin 
        @user = User.find(params[:id])
      rescue 
        flash[:danger] = "There was an error performing the operation."
        redirect_back fallback_location: current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
    end

    def verify_if_admin_and_redirect_with_error_message_if_not 
      unless current_user.is_admin?
        flash[:danger] = "You are not authorized to perform this action."
        redirect_to current_user
      end 
    end
end
