class ApplicationController < ActionController::API

  def render_error(message, errors = [], status = :bad_request)
    render json: {
      message: message,
      errors: Array(errors)
    }, status: status
  end

  # For missing/blank params
  def render_missing_param(param_key)
    render_error(
      "your query could not be completed",
      ["Missing required parameter: #{param_key}"]
    )
  end
end
