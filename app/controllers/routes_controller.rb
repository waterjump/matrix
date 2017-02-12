class RoutesController < ApplicationController
  def parse
    gateway = MatrixGateway.new
    gateway.perform
    sorter = Sorter.new
    sorter.perform
    gateway.send(sorter.results)
    if sorter.success
      render json: { status: 'OK' }, status: 200
    else
      render json: { status: 'failure' }, status: 500
    end
  end
end
