class Application < ActiveRecord::Base
  attr_accessible :installer_url, :name, :version, :image ,:begin_command, :base_command, :end_command, :description, :vm_type, :estimated_time, :installation_url
  validates :installer_url, :presence => true
  validates :version, :presence => true
  validates :description, :presence => true, :length => {:maximum => 140}
  validates :estimated_time, :presence => true, :numericality => {:less_than_or_equal_to => 600}

  has_many :clusters
  has_many :parameters ,:dependent => :destroy
  has_many :inputs , :dependent => :destroy

  mount_uploader :image, ImageUploader


  def app_info
    name + " (" + version + ")"
  end


end