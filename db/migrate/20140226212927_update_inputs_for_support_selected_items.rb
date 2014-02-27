class UpdateInputsForSupportSelectedItems < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
      add_column :inputs, :is_selecteditem, :boolean

  end
end
