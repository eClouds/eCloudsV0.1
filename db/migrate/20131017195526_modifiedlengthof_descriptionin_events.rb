class ModifiedlengthofDescriptioninEvents < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
     change_column :events, :description, :text, :limit => nil
  end
end
