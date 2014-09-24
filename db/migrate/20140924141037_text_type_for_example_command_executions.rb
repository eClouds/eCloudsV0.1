class TextTypeForExampleCommandExecutions < ActiveRecord::Migration
  def up
    change_column :executions, :example_command, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :executions, :example_command, :string
  end
end
