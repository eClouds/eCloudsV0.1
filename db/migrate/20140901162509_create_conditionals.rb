class CreateConditionals < ActiveRecord::Migration
  def change
    create_table :conditionals do |t|
      t.string :value
      t.integer :input_id_pre
      t.integer :input_id_post

      t.timestamps
    end
  end
end
