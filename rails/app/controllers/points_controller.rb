class PointsController < ApplicationController
  def index
    @points = Point.all
    respond_to do |format|
      format.html
      format.json { render json: RGeo::GeoJSON.encode(geojson) }
    end
  end

  def edit
    @point = Point.find_by(id: params[:id]) || Point.new
  end

  def new
    @point = Point.new
  end

  def create
    @point = Point.create(point_params)
    redirect_to point_path(@point)
  end

  def show
    @point = Point.find_by(id: params[:id])
  end

  def update
    @point = Point.find_by(id: params[:id])
    @point.update_attributes(point_params)
    redirect_to point_path(@point)
  end

  private

  def point_params
    params.require(:point).permit(:title, :region, :lat, :lng)
  end

  def geojson
    RGeo::GeoJSON::FeatureCollection.new(
      @points.map do |point|
        RGeo::GeoJSON::Feature.new(
          RGeo::Cartesian.factory.point(point.lng, point.lat),
          point.id,
          title: point.title,
          region: point.region,
          stories: point.stories
        )
      end
    )
  end
end
