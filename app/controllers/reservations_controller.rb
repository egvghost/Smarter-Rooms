class ReservationsController < ApplicationController
  before_action :set_room, only: [:new, :create]
  
  def index
  end

  def show
  end

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.room = @room
    @reservation.user = current_user

    if @reservation.save
      redirect_to @reservation, notice: "You have successfully reserved #{@room.name}"
    else
      redirect_to rooms_path, notice: "There was an error performing the operation. #{@reservation.errors.first.last}"
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully canceled.' }
      format.json { head :no_content }
    end
  end


  private
  
  def set_room
    @room = Room.find(params[:room_id])
  end

  def reservation_params
    params.require(:reservation).permit(:valid_from, :valid_to, :room_id, :user_id, :active)
    #whitelist creada para permitir SÓLO los parámetros listados, durante el POST del form
  end
  
end
