require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

    context "validation" do
      should validate_presence_of(:model)
    end

end
