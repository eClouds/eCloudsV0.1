class Conditional < ActiveRecord::Base
  attr_accessible :value, :input_id_post,:input_id_pre

  belongs_to  :input, :foreign_key => 'input_id_pre'
  has_one :input, :foreign_key => 'input_id_post'
end