class AddIsMultipleSelectedItemsToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :is_multiple_selecteditem, :boolean
  end
end
