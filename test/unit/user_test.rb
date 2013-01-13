require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "validation" do
    should validate_uniqueness_of(:github_id).scoped_to(:provider)
  end

end
