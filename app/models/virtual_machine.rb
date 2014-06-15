class VirtualMachine < ActiveRecord::Base
  attr_accessible :cores, :hostname, :localStorage, :ram , :cluster_id, :AMI_name, :slots, :is_busy, :execution_hours
  belongs_to :cluster

  has_many :jobs

  #acutaliza y salva el estado de la maq virtual
  def current_state

    if self.state == "terminated"
      return self.state
    else
      puts self.AMI_name
      @ec2 = Aws::Ec2.new(AMAZON_ACCESS_KEY_ID_EC2, AMAZON_SECRET_ACCESS_KEY_EC2)

      @vm_description = @ec2.describe_instances([self.AMI_name])

      @state = @vm_description[0][:aws_state]


      self.hostname = @vm_description[0][:private_dns_name]

      self.state = @state
      self.save

      return @state

    end





  end
end