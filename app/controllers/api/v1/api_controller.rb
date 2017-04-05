class API::V1::APIController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    respond_to do |format|
      format.json {
        render json: {status:404,error:"Not Found"},
               status: 404
      }
    end
  end
end