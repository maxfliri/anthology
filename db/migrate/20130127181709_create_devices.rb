class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :model
      t.string :image

      t.timestamps
    end
  end
end
