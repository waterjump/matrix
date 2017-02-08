class RoutesController < ApplicationController

  def parse
    sources = %w(sentinels sniffers loopholes)
    success = sources.each_with_object([]) do |src, results|
      gateway = MatrixGateway.new(src)
      results << gateway.call
    end
    render json: { status: success.all? ? 'OK' : 'Error'}
  end
end
