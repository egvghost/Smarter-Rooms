class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:new, :edit, :create, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms_selected_in_nav = true
    @paginated_rooms = Room.all.page params[:page]
    @paginated_rooms = @paginated_rooms.where(active: true) unless current_user.is_admin?
    @rooms = if params[:q]
      @paginated_rooms.where('name LIKE ?', "%#{params[:q]}%")
    else
      @rooms = @paginated_rooms
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    @buildings = Building.all
    @equipment = Accessory.all
  end

  # GET /rooms/1/edit
  def edit
    @buildings = Building.all
    @equipment = Accessory.all
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        flash[:success] = "Room was successfully created."
        format.html { redirect_to @room }
        format.json { render :show, status: :created, location: @room }
      else
        flash[:danger] = "There was an error performing the operation. #{@room.errors.first.last}"
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        flash[:success] = "Room information was successfully updated."
        format.html { redirect_to @room }
        format.json { render :show, status: :ok, location: @room }
      else
        flash[:danger] = "There was an error performing the operation. #{@room.errors.first.last}"
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      flash[:success] = "Room was successfully deleted."
      format.html { redirect_to rooms_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      begin 
        @room = Room.find(params[:id])
        (if !@room.is_active? 
          flash[:danger] = "The room you are trying to access is not available"
          redirect_to rooms_url
        end) unless current_user.is_admin?
      rescue 
        flash[:danger] = "Room not found"
        redirect_to rooms_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :code, :floor, :max_capacity, :active, :building_id, accessory_ids:[])
    end

    def verify_if_admin_and_redirect_with_error_message_if_not 
      unless current_user.is_admin?
        flash[:danger] = "You are not authorized to perform this action."
        redirect_to rooms_url
      end 
    end
end
