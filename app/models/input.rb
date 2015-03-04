class Input < ActiveRecord::Base

  #is_multiple_selecteditem es true es necesario que is_selected_item también sea true.
  attr_accessible :cloud_file_id, :description, :directory_id, :is_directory, :is_selecteditem, :is_multiple_selecteditem, :is_precondition, :is_file, :name, :value, :application_id, :prefix, :position, :execution_id, :visible

  validates :description, :length => { :maximum => 200}
  validates :name, :presence => true,:length => { :maximum => 50}

  belongs_to :application
  belongs_to :execution
  belongs_to :cloud_file
  belongs_to :directory

  has_many :selected_items
end