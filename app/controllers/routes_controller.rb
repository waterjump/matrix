class RoutesController < ApplicationController

  def parse
    success =
      Rails.application.config.source_names.each_with_object([]) do |src, results|
        gateway = MatrixGateway.new(src)
        results << gateway.call
      end
    render json: { status: success.all? ? 'OK' : 'Error'}
  end
end
