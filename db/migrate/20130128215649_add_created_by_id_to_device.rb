class AddCreatedByIdToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :created_by_id, :integer
  end
end
