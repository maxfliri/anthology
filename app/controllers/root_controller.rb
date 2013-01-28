class RootController < ApplicationController

  def start
    @books = resource_type.limit(8).all
    @recently_added_copies = Copy.recently_added.where(resource_type: resource_type).limit(3).all

    # start.html.erb
    render "#{resource_type.name.downcase.pluralize}/start" if template_exists? "#{resource_type.name.downcase.pluralize}/start"
  end

end
