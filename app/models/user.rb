class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable ,
         :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me , :current_directory
  # attr_accessible :title, :body
  #attr_protected :current_directory

  scope :pending_approval, where(:approved => false)

  has_many :clusters

  has_many :cloud_files

  has_many :directories

  has_many :virtual_machine_events

  has_many :jobs

  before_create { self.funds=4 }

  def to_s
    email
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super
    end
  end

  def set_approved
    if !approved?
      self.toggle!(:approved)
    end
  end

  def set_unapproved
    if approved?
      self.toggle!(:approved)
    end
  end

end
