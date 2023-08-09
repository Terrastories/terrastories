module SuperAdmin
  class FeaturesController < BaseController
    include FeatureFlipper

    def index
      @features = FlipperFeature.all.order(:key)
    end

    def show
      @feature = FlipperFeature.find_by(key: params[:id])
    end

    def new
      @feature = FlipperFeature.new
    end

    def create
      @feature = FlipperFeature.new(feature_params)

      if @feature.save
        redirect_to feature_path(@feature.key)
      else
        flash.alert = "Unable to create feature"
        render :new
      end
    end

    def edit
      @feature = FlipperFeature.find_by(key: params[:id])
    end

    def update
      @feature = FlipperFeature.find_by(key: params[:id])
      if @feature.update(feature_params)
        redirect_to feature_path(@feature.key)
      else
        flash.alert = "Unable to update feature"
        render :edit
      end
    end

    def destroy
      @feature = FlipperFeature.find_by(key: params[:id])
      @feature.remove

      flash.notice = "Feature Deleted: #{@feature.key}"
      redirect_to features_path
    end

    private

    def feature_params
      params.require(:flipper_feature).permit(
        :key, :description
      )
    end
  end
end
