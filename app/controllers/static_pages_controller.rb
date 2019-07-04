class StaticPagesController < ApplicationController
  skip_before_action :logged_in_user

  def home
    @home_selected_in_nav = true
  end

  def about
    @about_selected_in_nav = true
  end

end