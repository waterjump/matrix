Rails.application.routes.draw do
  get 'routes' => 'routes#parse', defaults: { format: 'json' }
end
