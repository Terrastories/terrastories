# Note: Feature Flipper should only be used on Super Admin routes!
module FeatureFlipper
  extend ActiveSupport::Concern

  def enable
    feature = FlipperFeature.find_by(key: params[:feature_id])
    feature.enable(
      actor: Community.find_by(id: params[:community_id]),
      group: params[:group]
    )
    redirect_to request.referrer
  end

  def disable
    feature = FlipperFeature.find_by(key: params[:feature_id])
    feature.disable(
      actor: Community.find_by(id: params[:community_id]),
      group: params[:group]
    )
    redirect_to request.referrer
  end
end
