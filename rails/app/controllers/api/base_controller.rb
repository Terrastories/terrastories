module Api
  class BaseController < ActionController::Base
    respond_to :json

    rescue_from ActiveRecord::RecordNotFound, with: :not_found


    helper_method :envelope
    def envelope(json, pageMeta = nil)
      json.data do
        yield if block_given?
      end
      if pageMeta
        json.meta do
          json.total @page.total
          json.hasNextPage @page.has_next_page?
          json.nextPageMeta @page.next_page_meta
        end
      end
    end

    protected

    def not_found
      render json: {
        error: "Not Found",
        message: "The requested resource could not be found."
      }, status: :not_found
    end
  end
end
