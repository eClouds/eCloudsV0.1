class ExecutionsController < InheritedResources::Base

  before_filter :authenticate_user!

  def index
    @executions =  Execution.find_all_by_user_id(current_user.id)
  end

  def show
    @inputs  = Input.find_all_by_execution_id(params[:id])
    @execution = Execution.find(params[:id])
  end

  def costs
    @date = Date.today
    @executions2 = Execution.where("end_date IS NOT NULL and start_date IS NOT NULL and start_date >= ?", @date) #and start_date > "+@date.to_s)
    @directories = current_user.directories
    @fileSize=0
    @cloud_files =  current_user.cloud_files
    @cloud_files.each do |file|
      @fileSize += file.size
    end

    @periodTotal = 0
    @computingTotal = 0
                                                                                                                 #Se calcula el costo total de las horas de computo
    @executions2.each do |exec|
      @computingTotal += exec.total_cost
    end
                                                                                                                 #Se suma al total del periodo el total por horas de computo
    @periodTotal += @computingTotal


    @directories.each do |direc|
      @cloud_files =  direc.cloud_files
      @cloud_files.each do |file|
        @fileSize += file.size
      end
    end

    #Se calcula el costo total por almacenamiento, se divide por el numero de bytes en un GB y se aproxima
    @moduli = (@fileSize%1000000000 == 0) ? 0:1
    @filesTotal = S3_PRICING["first-TB per GB"]*((@fileSize/1000000000)+@moduli)

    @periodTotal += @filesTotal
    @funds = current_user.funds - @periodTotal
    @month = @date.strftime("%B, %Y")

  end

  def compute_total_hours (exec)
    @vms = VirtualMachine.find_all_by_cluster_id(exec.cluster_id)
    @hours = 0
    @vms.each do |vm|
      @hours += vm.execution_hours
    end
    @hours
  end

  def launch_execution
    @execution = Execution.find(params[:id])

    if calculateRemainingFunds(current_user) - @execution.total_estimated_cost > 0

      @execution.user = current_user

      @now = DateTime.now

      @execution.start_date = @now

      #acá pongo el mensaje en la cola
      @sqs = Aws::Sqs.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)
      @queue = @sqs.queue(PRESCHEDULING_QUEUE, false )

      @msg = PROCESS_EXECUTION_MSG + ':' + @execution.id.to_s
      @queue.send_message(@msg)

      @event = Event.new(:code => 0, :description => EXECUTION_LAUNCHED+@execution.id.to_s, :event_date => @now)
      @event.execution = @execution
      @event.save

      respond_to do |format|
        if @execution.save
          format.html { redirect_to executions_path, notice: 'Your execution is being launched' }
          format.json { render json: @execution, status: :created, location: @execution}
        else
          format.html { render action: "new" }
          format.json { render json: @execution.errors, status: :unprocessable_entity }
        end
      end
    end
  else
    respond_to do |format|
      format.html { render action: "define_execution_part2" }
      @execution.errors.add(:total_estimated_cost,': Not Enough remaining funds to launch execution')
      format.json { render json: @execution.errors, status: :unprocessable_entity }
    end
  end

  def demo_execution
    @application = Application.find(params[:application_id])
    #Crear la ejecucion
    @now = DateTime.now
    @execution = Execution.new
    @execution.user_id = current_user.id
    @execution.name = "Demo execution-"+@now.to_default_s
    @execution.description = "This is the demo execution for app "+@application.name
    #Toca revisar si tiene sentido
    @execution.application = @application
    @execution.time_per_job = @application.estimated_time
    @execution.vm_type = @application.vm_type

    @num_jobs = 1
    @example_command = @application.begin_command + ' '
    @base_command = @application.begin_command + ' '

    @inputs = Input.find_all_by_application_id(@application.id)
    #Se asignan los valores a los inputs, se duplican
    i=0
    @exec_inputs_array ||= Array.new
    @inputs.each do |input|
      @execution_input = input.dup

      if input.is_file

        if @execution_input.prefix != nil or @execution_input.prefix != ''
          @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+ '}'+' '

        else
          @example_command = @example_command + '{'+@execution_input.value+ '}'+' '
        end

      elsif input.is_directory
        @directory = Directory.find(input.directory_id)
        @number_of_files = @directory.cloud_files.size
        @num_jobs = @num_jobs * @number_of_files

        if @execution_input.prefix != nil or @execution_input.prefix != ''
          @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+ '}'+' '
        else
          @example_command = @example_command +'{'+ @execution_input.value+'}'+' '
        end

      else

        if @execution_input.prefix != nil or @execution_input.prefix != ''
          @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+'}'+ ' '
        else
          @example_command = @example_command + '{'+ @execution_input.value+'}' + ' '
        end
      end
      @execution_input.application_id = nil
      @execution_input.save
      @exec_inputs_array.push(@execution_input)
      @base_command = @base_command+ ' '+@execution_input.prefix+' '+'INPUT'+i.to_s
      i=i+1
    end




    #Se crea un directorio llamado demo_executions y se asigna
    @output_dir = current_user.directories.new
    @output_dir.name = "DemoExec"+@now.to_default_s
    #Se busca el directorio Demo Results
    @demo_dir = Directory.where("user_id=? AND name=?",current_user.id,"Demo Results")[0]
    @output_dir.parent_id = @demo_dir.id
    @output_dir.save
    @execution.directory =  @output_dir



    @execution.example_command = @example_command + @application.end_command
    @execution.base_command = @base_command + @application.end_command
    @execution.number_of_jobs = @num_jobs

    @time_per_job = @execution.time_per_job
    @execution.computing_hours = ((@time_per_job*1.0 * @execution.number_of_jobs)/60).ceil
    @execution.computing_minutes = @time_per_job*1.0 * @execution.number_of_jobs
    @vm_type = @execution.vm_type
    @vm_cost = VM_PRICING[@vm_type]
    @execution.vm_cost = @vm_cost
    @execution.vm_number = @execution.computing_hours
    @execution.total_estimated_cost = @execution.vm_number * @vm_cost *1.0
    @execution.estimated_time_minutes = @execution.computing_minutes / @execution.vm_number

    #Se redirige al summary de la ejecucion
    respond_to do |format|
      if @execution.save
        @exec_inputs_array.each do |inp|
          inp.execution_id = @execution.id
          inp.save
        end
        format.html { redirect_to @execution, notice: 'Your execution is now ready to launch' }
        format.json { render json: @execution, status: :created, location: @execution}
      else
        format.html { render action: "new" }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end



  def create
    @execution = Execution.new(params[:execution])
    @execution.user_id = current_user.id
    @application = @execution.application

    #Oscar Garces modifico para que el número de jobs iniciara en 1, de lo contrario
    #Presenta errores por parámetros.
    @execution.number_of_jobs = 1
    @execution.time_per_job = @application.estimated_time
    @execution.vm_type = @application.vm_type
    puts 'CREATE EXECUTION'
    puts params
    respond_to do |format|
      if @execution.save
        format.html { redirect_to define_execution_path(@execution), notice: 'Define the inputs for your execution' }
        format.json { render json: @execution, status: :created, location: @execution}
      else
        format.html { render action: "new" }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  def define_execution

    @execution = Execution.find(params[:execution_id])

    @application = @execution.application

    @cloud_files = current_user.cloud_files.all+CloudFile.find_all_by_user_id(0)
    @directories = current_user.directories.all+Directory.find_all_by_is_public(true)
  end

  def new

    @execution = Execution.new
    @num_jobs = 1
    @execution.user_id = current_user.id

    #@uploader.success_action_redirect = cloud_files_url

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cloud_file }
    end
  end

  def update


    @execution = Execution.find(params[:id])

    @application = @execution.application

    @example_command = @application.begin_command + ' '
    @base_command = @application.begin_command + ' '


    # estos son los inputs escogidos por el usuario
    @raw_inputs = params['inputs']


    if params[:calculate]
      calculate_costs
      respond_to do |format|
        if @execution.save
          format.html { redirect_to define_execution_part2_path(@execution), notice: 'Define the parameters for your execution' }
          format.json { render json: @execution, status: :created, location: @execution}
        else
          format.html { render action: "new" }
          format.json { render json: @execution.errors, status: :unprocessable_entity }
        end
      end

    elsif  params[:summary]
      calculate_costs
      respond_to do |format|
        if @execution.save
          format.html { redirect_to @execution, notice: 'Your execution is now ready to launch' }
          format.json { render json: @execution, status: :created, location: @execution}
        else
          format.html { render action: "new" }
          format.json { render json: @execution.errors, status: :unprocessable_entity }
        end
      end

    elsif !@raw_inputs.nil?
      # este es el número de jobs total
      @num_jobs = 1

      @output_dir = Directory.find(@raw_inputs['output_dir'].to_i)

      @execution.directory =  @output_dir
      i=0
      @application.inputs.order('position asc').each do |app_input|
        @raw_input = @raw_inputs[i.to_s]
        @execution_input = app_input.dup
        if app_input.visible?

          if app_input.is_file
            @file_id = @raw_input.to_i
            @cloud_file = CloudFile.find(@file_id)

            @execution_input.cloud_file = @cloud_file
            @execution_input.value = @cloud_file.name

            if @execution_input.prefix != nil or @execution_input.prefix != ''

              @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+ '}'+' '

            else
              @example_command = @example_command + '{'+@execution_input.value+ '}'+' '

            end

          elsif app_input.is_directory

            @directory_id = @raw_input.to_i
            @directory = Directory.find(@directory_id)

            @execution_input.directory = @directory
            @execution_input.value = 'DIR('+@directory.name+')'
            @number_of_files = @directory.cloud_files.size
            @num_jobs = @num_jobs * @number_of_files

            if @execution_input.prefix != nil or @execution_input.prefix != ''

              @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+ '}'+' '

            else
              @example_command = @example_command +'{'+ @execution_input.value+'}'+' '

            end

          elsif app_input.is_selecteditem

            @input_value = @raw_input
            puts "------------------------------------ " + @raw_input.to_s
            puts @raw_inputs
            @execution_input.value = @input_value

            if @execution_input.prefix != nil or @execution_input.prefix != ''

              @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+'}'+ ' '

            else
              @example_command = @example_command + '{'+ @execution_input.value+'}' + ' '

            end


          else
            @input_value = @raw_input
            @execution_input.value = @input_value

            if @execution_input.prefix != nil or @execution_input.prefix != ''

              @example_command = @example_command +'{'+@execution_input.prefix + ' '+ @execution_input.value+'}'+ ' '

            else
              @example_command = @example_command + '{'+ @execution_input.value+'}' + ' '

            end
          end

          @execution_input.execution_id =  @execution.id
          @execution_input.application_id = nil
          @execution_input.save

          puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

          puts @base_command

          @base_command = @base_command+ ' '+@execution_input.prefix+' '+'INPUT'+i.to_s

        end
        i=i+1
      end

      puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

      puts @num_jobs

      @execution.example_command = @example_command + @application.end_command
      @execution.base_command = @base_command + @application.end_command
      @execution.number_of_jobs = @num_jobs

      respond_to do |format|
        if @execution.save
          format.html { redirect_to define_execution_part2_path(@execution), notice: 'Define the parameters for your execution' }
          format.json { render json: @execution, status: :created, location: @execution}
        else
          format.html { render action: "new" }
          format.json { render json: @execution.errors, status: :unprocessable_entity }
        end
      end

    else
      puts 'HOLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
      @execution = Execution.find(params[:id])
      @execution.user_id = current_user.id
      @application = @execution.application
      @execution.time_per_job = @application.estimated_time
      @execution.vm_type = @application.vm_type
      respond_to do |format|
        if @execution.update_attributes(params[:execution])
          format.html { redirect_to define_execution_path(@execution), notice: 'Define the inputs for your execution' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @execution.errors, status: :unprocessable_entity }
        end
      end
    end



  end


  def calculate_costs
    @execution_params = params["execution_params"]

    @time_per_job = @execution_params["time_per_job"].to_i

    @execution.time_per_job=@time_per_job

    @execution.computing_hours = ((@time_per_job*1.0 * @execution.number_of_jobs)/60).ceil

    @execution.computing_minutes = @time_per_job*1.0 * @execution.number_of_jobs

    @vm_type = @execution_params["instance_type"]

    @execution.vm_type = @vm_type

    @vm_cost = VM_PRICING[@vm_type]

    @execution.vm_cost = @vm_cost

    @execution.vm_number = @execution.computing_hours

    @execution.total_estimated_cost = @execution.vm_number * @vm_cost *1.0

    @execution.estimated_time_minutes = @execution.computing_minutes / @execution.vm_number


  end

  def define_execution_part2

    @execution = Execution.find(params[:execution_id])

    @application = @execution.application

    @cloud_files = current_user.cloud_files.all
    @directories = current_user.directories.all


  end


  def calculateRemainingFunds(current_user)
    @date = Date.today
    @executions2 = Execution.where("end_date IS NOT NULL and start_date IS NOT NULL and start_date >= ?", @date) #and start_date > "+@date.to_s)
    @directories = current_user.directories
    @fileSize=0
    @cloud_files =  current_user.cloud_files
    @cloud_files.each do |file|
      @fileSize += file.size
    end
    @periodTotal = 0
    @computingTotal = 0
                                                                                                                 #Se calcula el costo total de las horas de computo
    @executions2.each do |exec|
      @computingTotal += exec.total_cost
    end
                                                                                                                 #Se suma al total del periodo el total por horas de computo
    @periodTotal += @computingTotal


    @directories.each do |direc|
      @cloud_files =  direc.cloud_files
      @cloud_files.each do |file|
        @fileSize += file.size
      end
    end

    #Se calcula el costo total por almacenamiento, se divide por el numero de bytes en un GB y se aproxima
    @moduli = (@fileSize%1000000000 == 0) ? 0:1
    @filesTotal = S3_PRICING["first-TB per GB"]*((@fileSize/1000000000)+@moduli)

    @periodTotal += @filesTotal
    return current_user.funds - @periodTotal

  end


end
