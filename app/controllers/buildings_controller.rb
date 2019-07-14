class BuildingsController < ApplicationController
  before_action :set_building, only: [:show, :edit, :update, :destroy]
  before_action :verify_if_admin_and_redirect_with_error_message_if_not, only: [:new, :edit, :create, :update, :destroy]

  # GET /buildings
  # GET /buildings.json
  def index
    @buildings_selected_in_nav = true
    @buildings = Building.all
  end

  # GET /buildings/1
  # GET /buildings/1.json
  def show
  end

  # GET /buildings/new
  def new
    @building = Building.new
  end

  # GET /buildings/1/edit
  def edit
  end

  # POST /buildings
  # POST /buildings.json
  def create
    @building = Building.new(building_params)

    respond_to do |format|
      if @building.save
        flash[:success] = "Building was successfully created."
        format.html { redirect_to @building }
        format.json { render :show, status: :created, location: @building }
      else
        flash[:danger] = "There was an error performing the operation. #{@building.errors.full_messages.first}"
        format.html { redirect_back fallback_location: buildings_path }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buildings/1
  # PATCH/PUT /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        flash[:success] = "Building information was successfully updated."
        format.html { redirect_to @building }
        format.json { render :show, status: :ok, location: @building }
      else
        flash[:danger] = "There was an error performing the operation. #{@building.errors.full_messages.first}"
        format.html { redirect_back fallback_location: @building }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      flash[:success] = "Building was successfully deleted."
      format.html { redirect_to buildings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building
      @building = Building.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_params
      params.require(:building).permit(:name, :address, :coordinates)
    end

    def verify_if_admin_and_redirect_with_error_message_if_not 
      unless current_user.is_admin?
        flash[:danger] = "You are not authorized to perform this action."
        redirect_to buildings_url
      end 
    end
end
