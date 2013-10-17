class ModifiedlengthofDescriptioninEvents < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
     change_column :Event, :description, :limit => nil
  end
end
