class Execution < ActiveRecord::Base
  attr_accessible :application_id, :description, :directory_id, :end_date, :name, :start_date, :user_id, :base_command, :number_of_jobs, :computing_hours, :time_per_job, :computing_minutes, :vm_cost, :vm_number, :total_estimated_cost, :vm_type, :estimated_time_minutes, :cluster_id, :example_command, :queue_name, :running_jobs, :finished_jobs, :current_vms, :ended, :total_cost

  validates :name, :presence => true, :length => { :maximum => 50}
  #validates :total_estimated_cost, :numericality => {:less_than_or_equal_to => 20}
  validates :time_per_job, :numericality => {:less_than_or_equal_to => 2000}
  validates :number_of_jobs, :numericality => {:greater_than => 0}
  belongs_to :user
  belongs_to :application
  has_many :jobs, :dependent => :destroy
  has_many :events, :dependent => :destroy
  belongs_to :directory
  has_many :inputs , :dependent => :destroy
  has_one :cluster , :dependent => :destroy
  #default_scope order(:start_date, :name)
  default_scope order('start_date desc')


  def completed?
    self.directory_id.nil?
  end

  def launched?
    self.start_date.nil? && !self.ended?
  end

  def ended?
    if self.ended == true
       true
    else
      false
    end
  end
end