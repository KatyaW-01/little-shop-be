class Api::V1::ItemsSearchController < ApplicationController
  resuce_from ActionController::ParameterMissing, with: :missing_param_response
  resuce_from ArgumentError, with: :incomplete_response

  def find
    
  end
end