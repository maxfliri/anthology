class ChangeCopyAssociationToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :copies, :book_id, :resource_id
    rename_column :copies, :book_reference, :reference
    add_column :copies, :resource_type, :string, :default => "Book"
  end
end
