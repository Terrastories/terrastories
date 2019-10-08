module Import
  extend ActiveSupport::Concern

  def import
    if params[:file].nil?
      flash[:error] = "No file was attached!"
    else
      begin
        controller_name.classify.constantize.import(params[:file].read)
        flash[:notice] = "Points were imported successfully!"
      rescue ImportError => e
        flash[:error] = e.message
      end
    end

    redirect_to action: :index
  end
end
