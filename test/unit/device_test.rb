require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

    context "validation" do
      should validate_presence_of(:model)
    end

  context "creating a device" do
    should "create an initial copy upon creation" do
      device = FactoryGirl.create(:device)

      assert_equal 1, device.copies.count
    end

    should "set the creating user" do
      user = FactoryGirl.create(:user)
      device = FactoryGirl.create(:device, :created_by => user)

      assert_equal user.id, device.created_by.id
    end

  end

end
