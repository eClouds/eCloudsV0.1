class SelectedItem < ActiveRecord::Base
   attr_accessible :name, :value

  belongs_to :input
end
