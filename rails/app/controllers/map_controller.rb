class MapController < ApplicationController
    skip_before_action :set_locale, :authenticate_user!, only: [:serve]
    def serve
      path = params[:path]
      file_path = Rails.root.join('/map', path)
  
      if File.exists?(file_path)
        if request.headers["Range"]
          send_partial_file(file_path, request.headers["Range"])
        else
          send_file file_path, disposition: 'inline', type: 'application/octet-stream'
        end
      else
        render plain: 'File not found', status: 404
      end
    end
  
    private
  
    def send_partial_file(file_path, range)
      start, finish = range.match(/bytes=(\d+)-(\d+)/).captures
      length = finish.to_i - start.to_i + 1
      content = IO.binread(file_path, length, start.to_i)
  
      response.headers["Content-Range"] = "bytes #{start}-#{finish}/#{File.size(file_path)}"
      response.headers["Accept-Ranges"] = "bytes"
      response.headers["Content-Length"] = length.to_s
  
      render plain: content, status: :partial_content
    end
  end
  