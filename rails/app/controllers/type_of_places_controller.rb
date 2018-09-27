class TypeOfPlacesController < ApplicationController
  before_action :set_type_of_place, only: [:show, :edit, :update, :destroy]

  # GET /type_of_places
  # GET /type_of_places.json
  def index
    @type_of_places = TypeOfPlace.all
  end

  # GET /type_of_places/1
  # GET /type_of_places/1.json
  def show
  end

  # GET /type_of_places/new
  def new
    @type_of_place = TypeOfPlace.new
  end

  # GET /type_of_places/1/edit
  def edit
  end

  # POST /type_of_places
  # POST /type_of_places.json
  def create
    @type_of_place = TypeOfPlace.new(type_of_place_params)

    respond_to do |format|
      if @type_of_place.save
        format.html { redirect_to @type_of_place, notice: 'Type of place was successfully created.' }
        format.json { render :show, status: :created, location: @type_of_place }
      else
        format.html { render :new }
        format.json { render json: @type_of_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_of_places/1
  # PATCH/PUT /type_of_places/1.json
  def update
    respond_to do |format|
      if @type_of_place.update(type_of_place_params)
        format.html { redirect_to @type_of_place, notice: 'Type of place was successfully updated.' }
        format.json { render :show, status: :ok, location: @type_of_place }
      else
        format.html { render :edit }
        format.json { render json: @type_of_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_of_places/1
  # DELETE /type_of_places/1.json
  def destroy
    @type_of_place.destroy
    respond_to do |format|
      format.html { redirect_to type_of_places_url, notice: 'Type of place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_of_place
      @type_of_place = TypeOfPlace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_of_place_params
      params.require(:type_of_place).permit(:name)
    end
end
