Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, { :fields => [:id, :name, :nickname], :uid_field => :id } unless Rails.env.production?
  provider :google_apps, :name => 'open_id', :domain => ENV["GOOGLE_APPS_DOMAIN"]
end

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.failure_app = SessionsController.action(:failure)
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id) rescue false
end
