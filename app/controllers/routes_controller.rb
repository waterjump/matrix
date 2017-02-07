class RoutesController < ApplicationController

  def parse
    @success = 'Success'
    render json: { status: @success }
  end
end
