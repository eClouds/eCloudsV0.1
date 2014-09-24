# Acá inicializo constantes y cosas generales de la app

VIRTUAL_MACHINE_EVENTS = { :STARTED => "STARTED",
                           :STOPPED => "STOPPED",
                           :REBOOTED=>"REBOOTED",
                           :TERMINATED => "TERMINATED",
                           :CREATED => "CREATED"}

JOBS_STATUS =  { :PENDING=> "PENDING",
                 :PREPARING => "PREPARING",
                 :WAITING => "WAITING",
                 :QUEUED => "QUEUED",
                 :INSTALLING => "INSTALLING",
                 :RUNNING =>"RUNNING",
                 :FAILED => "FAILED",
                 :UPLOADING_OUTPUTS => "UPLOADING_OUTPUTS",
                 :FINISHED => "FINISHED",
                 :ASSIGNING => "ASSIGNING"}

VM_PRICING = {"t1.micro"  => 0.020,
              "m1.small"  => 0.065,
              "c1.medium"  => 0.165,
              "m1.large"  => 0.260,
              "m1.xlarge"  => 0.520,
              "c1.xlarge" => 0.660}

S3_PRICING = {"first-TB per GB" =>0.095
              }

AWS_ACCESS_KEY_ID = ENV["AMAZON_ACCESS_KEY_ID"]

AWS_SECRET_ACCESS_KEY = ENV["AMAZON_SECRET_ACCESS_KEY"]



PROCESS_EXECUTION_MSG = 'PROCESS_EXECUTION'

ASSIGN_EXECUTION_MSG = 'ASSIGN_EXECUTION'

SWITCH_TO_QUEUE_MSG = 'SWITCH_TO_QUEUE'

SCHEDULE_JOB_MSG = 'SCHEDULE_JOB'
RUN_JOB_MSG = 'RUN_JOB'
INSTALLING_APP_MSG = 'INSTALLING_APP'
RUNNING_APP_MSG = 'RUNNING_APP_MSG'
UPLOADING_OUTPUTS_MSG = 'UPLOADING_OUTPUTS_MSG'
REGISTER_FILE_MSG = 'REGISTER_FILE_MSG'
FINISHED_JOB_MSG = 'FINISHED_JOB_MSG'


EXECUTION_LAUNCHED = 'The execution has been launched, waiting for the scheduler: '
LAUNCHED_VM= 'The following VM has been started:'
CREATED_JOB = 'The following job has been created: '
SWITCHED_TO_QUEUE = 'The VM switched to queue: '
INSTALLING_APP='The VM is installing the application: '
RUNNING_APP='The VM is running the assigned job: '
UPLOADING_OUTPUTS='The outputs are being uploaded: '
REGISTER_FILE='The following file is available: '
FINISHED_JOB='The following job has finished: '
VM_SHUTDOWN='The following virtual machine is shuting down:'
EXECUTION_FINISHED='The following execution has finished: '



if Rails.env.production?

  PRESCHEDULING_QUEUE = 'preschedulingProduction'
  SCHEDULING_QUEUE = 'schedulingProduction'
  S3_BUCKET = ENV["S3_BUCKET_PROD"]

elsif Rails.env.development?
  PRESCHEDULING_QUEUE = 'preschedulingDevelopment'
  SCHEDULING_QUEUE = 'schedulingDevelopment'
  S3_BUCKET = ENV["S3_BUCKET_DEV"]

else
  PRESCHEDULING_QUEUE = 'preschedulingDevelopment'
  SCHEDULING_QUEUE = 'schedulingDevelopment'
  S3_BUCKET = ENV["S3_BUCKET_STAGING"]
end