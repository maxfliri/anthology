module DevicesHelper
  def device_image_tag(device)
    image_tag image_for(device), :alt => "#{device.model}"
  end

  def image_for(device)
    device.image.present? ? device.image : "mobile.png"
  end
end
