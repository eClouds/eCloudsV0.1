class CreateSelectedItems < ActiveRecord::Migration

  def up
    SelectedItem.create(:value => "nt", :value=> 'nt.gz').save
  end
  def change
    create_table :selected_items do |t|
        t.string :name
        t.string :value
        t.integer :input_id
        t.timestamps
    end
  end
end
