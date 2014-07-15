#version=1.0
task :checkJobsQueue => :environment do



  puts 'I will check if I have an execution queue assigned'

  if File.exist?('exec_queue_name')

    puts 'reading file exec_queue_name'


    File.open('exec_queue_name', "r") do |infile|
      while (line = infile.gets)
        puts line
        @queue_name = line.chop
      end
    end

    puts 'I will check the queue for messages'
    puts 'using queue: '+ @queue_name
    @sqs = Aws::Sqs.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)
    @queue = @sqs.queue(@queue_name,false )

    puts 'I will check the queue for messages'

    @msg = @queue.receive


    puts 'I just received the message: '
    puts @msg

    puts 'I will get my hostname to register my status: '
    @host = Socket.gethostname
    puts @host

    @msg_parts = @msg.to_s.split(';')

    if @msg_parts[0] == RUN_JOB_MSG

      puts 'I will check if another process is running a job '

      if !File.exist?('running_job')

        puts 'I will register a file that says that I am running a job '

        File.open('running_job', 'w') do |stream|


          stream.puts 'CURRENTLY RUNNING ANOTHER QUEUE'

        end

        #borro el mensaje
        @msg.delete

        # my queue for moniroring will be the same as for prescheduling

        @queue_monitoring = @sqs.queue(PRESCHEDULING_QUEUE,false )

        puts 'All the monitoring messages will me sent to '
        puts @queue_monitoring



        @app_installer_url = @msg_parts[2].to_s
        @installation_file_name = @app_installer_url.split('/').last

        @installing_msg = INSTALLING_APP_MSG+';'+ @msg_parts[1].to_s
        @queue_monitoring.send_message(@installing_msg)

        puts 'Creating output dir'
        system( 'mkdir jobsOutputs')


        if( File.exists? @installation_file_name )
          puts 'application already installed'
        else

          puts 'I will download the installer file'
          puts '########################################'
          puts 'wget ' + @app_installer_url

          system('wget ' + @app_installer_url )


          puts '########################################'
          puts 'chmod 755 '+ @installation_file_name

          system( 'chmod 755 '+ @installation_file_name )

          puts 'Now I will execute the installer file'
          system( 'chown root '+ @installation_file_name)
          system( 'sudo ./'+@installation_file_name+' 2> jobsOutputs/errors.txt')

          system( 'touch '+@installation_file_name)

        end


        system( 'cd jobsOutputs')



        puts 'I will download the command file'
        @command_url = @msg_parts[3].to_s

        puts '########################################'
        puts 'wget ' + @command_url

        system('wget ' + @command_url )

        @running_msg = RUNNING_APP_MSG+';'+ @msg_parts[1].to_s+';'+@host
        @queue_monitoring.send_message(@running_msg)

        @command_file_name = @command_url.split('/').last

        puts '########################################'
        puts 'chmod 755 ' + @command_file_name
        system( 'chmod 755 ' + @command_file_name )


        puts '../'+@command_file_name + ' > jobsOutputs/output.txt 2>> jobsOutputs/errors.txt'
        system( '../'+@command_file_name + ' > jobsOutputs/output.txt 2>> jobsOutputs/errors.txt' )

        puts 'I will upload the outputs'

        @uploading_outs_msg = UPLOADING_OUTPUTS_MSG+';'+ @msg_parts[1].to_s
        @queue_monitoring.send_message(@uploading_outs_msg)

        @outputFiles = Dir['jobsOutputs/*']

        @job_id = @msg_parts[1].to_s

        @s3 = Aws::S3.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)
        @bucket = @s3.bucket('EcloudsStaging')

        for i in 0..(@outputFiles.size-1) do

          @file = @outputFiles[i]

          @filename = @file.split('/').last

          puts 'uploading '+@filename.to_s
          f=File.open(@file, 'r')

          # el permiso que toca ponerle es public-read
          @bucket.put('outputs/'+@job_id +'/'+ @filename, f, {}, 'public-read')

          @location = @bucket.public_link
          @fileUrl = @location + '/outputs/'+@job_id+'/'+@filename.to_s

          puts 'successfully uploaded command file to ' + @fileUrl

          @registerFile = REGISTER_FILE_MSG+';'+ @msg_parts[1].to_s+';'+@fileUrl
          @queue_monitoring.send_message(@registerFile)

          File.delete(@file)

        end





        @finished_job_msg = FINISHED_JOB_MSG+';'+ @msg_parts[1].to_s+';'+@host
        @queue_monitoring.send_message(@finished_job_msg)

        puts 'I will delete the file that represents that I am busy'

        File.delete('running_job')

      else

        puts 'another process is running a job, I will wait'
      end




    end


  else
    puts 'I still do not have any queue assigned'
  end















end

task :getAssignedQueue => :environment do

  i=0

  while i < 10 do

    sleep 5
    i=i+1

    puts 'I wil check the queue to see which queue I have to use'

    @sqs = Aws::Sqs.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)
    @queue = @sqs.queue(PRESCHEDULING_QUEUE, false)

    @msg = @queue.receive

    puts 'I just received the message:'
    puts @msg

    if @msg.to_s.split(';')[1] == SWITCH_TO_QUEUE_MSG and @msg.to_s.split(';').first != ''
      @msg_parts = @msg.to_s.split(';')

      @msg_parts = @msg.to_s.split(';')

      @host = Socket.gethostname
      @host = @host.split('.').first
      puts 'my hostname is: '
      puts @host.to_s

      @targetHostname = @msg_parts[0].split('.').first
      puts 'the target hostname is: '
      puts @targetHostname

      if @targetHostname != @host
        puts 'this is not for me '
      else
        # acá cojo la cola que me tocó
        @exec_queue_name = @msg_parts[2]

        puts 'They assigned the queue ' +@exec_queue_name + ' for me'
        puts 'I will save it in the file exec_queue_name'

        File.open('exec_queue_name', 'w') do |stream|


          stream.puts @exec_queue_name

        end

        puts 'DONE'

        @msg.delete

        @message = SWITCHED_TO_QUEUE + ";"+@exec_queue_name
        @queue.send_message(@message)

      end
    end

  end



end