class AddTrashedToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :trashed, :boolean, default: false, null: false
  end
end
