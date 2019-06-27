class UsersController < ApplicationController 
    before_action :set_user, only: [:show]
    skip_before_action :logged_in_user, only: [:new, :create]
  
    def show
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params) 
        if @user.save
            log_in @user
            redirect_to @user, notice: 'User was successfully created.'
        else
            render 'new'
        end
    end


    private
    
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 

end