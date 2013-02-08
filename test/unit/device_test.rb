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

  context "trashing a device" do
    should "set the device as trashed" do
      device = FactoryGirl.create(:device, trashed: false)

      device.trash!

      assert_equal true, device.trashed
    end

    should "set the device as untrashed" do
      device = FactoryGirl.create(:device, trashed: true)

      device.untrash!

      assert_equal false, device.trashed
    end
  end

  should "return the model as title" do
    device = FactoryGirl.build(:device, :model => "XYZ")

    assert_equal device.title, "XYZ"
  end

end
