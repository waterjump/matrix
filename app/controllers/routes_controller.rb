class RoutesController < ApplicationController

  def parse
    gateway = MatrixGateway.new
    if gateway.perform
      render json: { status: 'OK' }, status: 200
    else
      render json: { status: 'failure' }, status: 500
    end
  end
end
