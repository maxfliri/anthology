require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "validation" do
    should validate_uniqueness_of(:uid).scoped_to(:provider)
  end

end
