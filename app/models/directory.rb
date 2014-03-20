class Directory < ActiveRecord::Base
  acts_as_tree
  attr_accessible :name, :path, :parent_id, :updated_at, :is_public
   belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 50}

  has_many :cloud_files, :dependent => :destroy
  has_many :jobs
  has_many :executions

  default_scope order('updated_at desc')
  
end
