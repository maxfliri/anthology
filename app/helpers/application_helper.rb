module ApplicationHelper

  def warden
    request.env['warden']
  end

  def authenticate!
    warden.authenticate!
  end

  def current_user
    warden.user
  end

  def library_title
    ENV['LIBRARY_TITLE'] || "Library"
  end

  def resource_image_tag(resource)
    tag_method = :"#{resource.class.name.downcase}_image_tag"
    send(tag_method, resource)
  end

  def resource_type
    (ENV['LIBRARY_RESOURCE'] || "Book").constantize
  end

  def resource_name
    resource_type.name.downcase
  end
end
