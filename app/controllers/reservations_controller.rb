class ReservationsController < ApplicationController
  before_action :set_room, only: [:new, :create]
  before_action :verify_if_active_and_redirect_with_error_message_if_not, only: [:new, :create]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:all]

  def index
  end

  def all
    @reservations_selected_in_nav = true
    @reservations = Reservation.all
  end

  def show
    @reservation = Reservation.find(params[:id])
    @room = @reservation.room
    if (@reservation.attendants? && @room.max_capacity? && @reservation.attendants > @room.max_capacity)
      flash.now[:warning] = "Take into consideration that there might not be enough sits for all attendants."
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
      flash[:danger] = "There was an error performing the operation. #{@reservation.errors.first.last}"
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


  private
  
  def set_room
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:valid_from, :valid_to, :room_id, :user_id, :active, :attendants)
    #whitelist creada para permitir SÓLO los parámetros listados, durante el POST del form
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
