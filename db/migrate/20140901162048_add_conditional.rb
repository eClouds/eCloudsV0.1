class AddConditional < ActiveRecord::Migration
  def change
    add_column :inputs, :is_precondition, :boolean
  end
end
