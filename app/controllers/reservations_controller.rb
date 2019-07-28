class ReservationsController < ApplicationController
  before_action :set_room, only: [:new, :create]
  before_action :verify_if_active_and_redirect_with_error_message_if_not, only: [:new, :create]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:all, :charts]

  def index
  end

  def show
    begin 
      @reservation = Reservation.find(params[:id])
      unless (current_user.is_admin? || current_user == @reservation.user)
        flash[:danger] = "You are not authorized to perform this action."
        redirect_to reservations_url
      end 
      @room = @reservation.room
      if (@reservation.attendants? && @room.max_capacity? && @reservation.attendants > @room.max_capacity)
        flash.now[:warning] = "Take into consideration that there might not be enough sits for all attendants."
      end
    rescue 
      flash[:danger] = "Reservation not found"
      redirect_to all_reservations_url
    end
  end

  def new
    @reservation = Reservation.new
    if current_user.reservations.active.where(room_id: @room.id).exists?
      flash.now[:info] = "You already have an active reservation on this room 
      from: #{current_user.reservations.active.find_by(room_id: @room.id).valid_from} 
      to: #{current_user.reservations.active.find_by(room_id: @room.id).valid_to}"
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.room = @room
    @reservation.user = current_user

    if @reservation.save
      flash[:success] = "You have successfully reserved room '#{@room.name}'."
      redirect_to @reservation
    else
      flash[:danger] = "There was an error performing the operation. #{@reservation.errors.messages.first.last.first}"
      redirect_back fallback_location: rooms_path
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id]).destroy
    respond_to do |format|
      flash[:success] = "Reservation was successfully canceled."
      format.html { redirect_back fallback_location: reservations_url }
      format.json { head :no_content }
    end
  end

  def all
    @reservations_selected_in_nav = true
    @reservations = Reservation.all
  end

  def charts
    @charts_selected_in_nav = true

    #Percentage of time reserved per room per day [Last week]
    @chart1 = Room
    .joins(:reservations)
    .merge(Reservation.last_week.business_hours)
    .group(:name)
    .group("date(valid_from)")
    .sum(:duration)
    .map{|k,v| [k,(v/9*100).round(2)]}.to_h

    #Percentage of rooms reserved per hour [Last month]
    @chart2 = {}
    for i in (9..18)
      @chart2["#{i}:00"] = ((Reservation
      .last_month
      .business_hours
      .reserved_in(i)
      .group(:room_id)
      .count.count)
      .to_f * 100/Room.count).round(2)
    end

    #Users with more reservations [Last month]
    @chart3 = User
    .joins(:reservations)
    .merge(Reservation.last_month)
    .group(:name)
    .order('count_id desc')
    .count('id')
    .take(5)

    #Rooms with more reservations [Last month]
    @chart4 = Room
    .joins(:reservations)
    .merge(Reservation.last_month)
    .group(:name)
    .order('count_id desc')
    .count('id')
    .take(5)
  end

  def schedule
    @building_id = params[:reservation][:building_id].to_i
    @attendants = params[:reservation][:attendants].to_i
    #@equipment = params[:reservation][:accessory_ids]
    params[:reservation].delete(:building_id)
    #params[:reservation].delete(:accessory_ids)
    @reservation = Reservation.new(reservation_params)
    @rooms = Room
    .where(active: true)
    .where(building_id: @building_id)
    .where("max_capacity >= ?", @attendants)
    #.joins(:accessories)
    #.where("accessory_id IN (?)", @equipment) #must be fixed to include only rooms with required equipment
    ##add additional queries to filter for rooms without reservations in the selected timeframe
    render "static_pages/home"
  end
  
  def reserve
    @reservation = Reservation.new
    @reservation.valid_from = params[:valid_from]
    @reservation.valid_to = params[:valid_to]
    @reservation.attendants = params[:attendants]
    @reservation.room_id = reservation_params[:room_id].to_i
    @reservation.user = current_user

    if @reservation.save
      flash[:success] = "You have successfully reserved room '#{@reservation.room.name}'."
      redirect_to @reservation
    else
      flash[:danger] = "There was an error performing the operation. #{@reservation.errors.messages.first.last.first}"
      redirect_to :controller => 'static_pages', :action => 'home' 
    end
  end
  

  private
  
  def set_room
    byebug
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:valid_from, :valid_to, :room_id, :user_id, :active, :attendants)
  end

  def verify_if_active_and_redirect_with_error_message_if_not 
    unless @room.active
      flash[:danger] = "Room '#{@room.name}' is out of service at this moment. Please choose another room."
      redirect_to rooms_url
    end 
  end

  def verify_if_admin_and_redirect_with_error_message_if_not 
    unless current_user.is_admin?
      flash[:danger] = "You are not authorized to perform this action."
      redirect_to reservations_url
    end 
  end
  
end
