class ApplicationsController < InheritedResources::Base


  before_filter :authenticate_admin_user!, :only => [:edit,:new, :create, :add_inputs, :add_parameters, :add_one_input, :organize_parameters, :update, :decrease_position_parameter, :increase_position_parameter]



  def new
    @application = Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @application }
    end
  end

  # POST /operating_systems
  # POST /operating_systems.json
  def create
    @application = Application.new(params[:application])
    @application.estimated_time = 0
    session[:current_application_id]=@application

    respond_to do |format|
      if @application.save
        puts "Guardo correctamente-------------------------------------"
        format.html { redirect_to add_inputs_path(@application), notice: 'Application was successfully created.' }
        puts "Redirijio------------------------------------------------"
        format.json { render json: @application, status: :created, location: @application}
      else
        format.html { render action: "new" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_inputs
    puts "Entro a add inputs-----......................."
    @application = Application.find(params[:application_id])
    puts "Hasta aqui llego-----------------------"
    @input = @application.inputs.new
    @directories = Directory.find_all_by_is_public(true)
    @cloud_files = CloudFile.find_all_by_user_id(0)

  end

  def add_parameters
    @application = Application.find(params[:application_id])
    @parameter = @application.parameters.new

  end


  def add_one_input
    @application = Application.find(params[:application_id])
    @input =  Input.find(params[:input_id])
    @input.name =  params[:name]
    puts params
    @input.application_id = @application.id

    if@input.is_directory?
      @directory = Directory.find(@input.value.to_i)
      @input.directory = @directory
      @input.value = 'DIR('+@directory.name+')'

    elsif @input.is_file?
      @cloud_file = CloudFile.find(@input.value.to_i)
      @input.cloud_file = @cloud_file
      @input.value = @cloud_file.name

    end
    respond_to do |format|
      if @input.save
        format.html { redirect_to add_inputs_path(@application), notice: 'Input successfully added.' }
        format.json { render json: @application, status: :created, location: @application}
      else
        format.html { render action: "new" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end

    redirect_to add_inputs_path(@application)

  end

  def organize_parameters
    @application = Application.find(params[:application_id])


    # si no están ordenados los organiza
    @ordered_inputs = @application.inputs.order('position asc')

    puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    i=1
    @ordered_inputs.each do |input|

      puts input.name
      puts input.position


      if input.position==nil or input.position==0 or input.position != i

        input.position = i
        input.save
        puts 'changed'
      end

      puts '--------------------------------------------'

      i=i+1
    end

    @application.save



    @precommand_example =''
    @precommand_base =''
    @precommand_example_names=''



    i=0
    @ordered_inputs.each do |input|
      i=i+1
      @value_example
      @value_base
      @value_example_names
      if input.value == nil || input.value == ''
        @value_example = input.prefix + ' INPUT'+i.to_s
      else
        @value_example = input.prefix + ' ' +input.value
      end

      @value_base = input.prefix + ' INPUT'+i.to_s
      @value_example_names = input.prefix + ' '+ input.name

      @precommand_example = @precommand_example + ' ' + @value_example
      @precommand_base =  @precommand_base + ' ' + @value_base
      @precommand_example_names = @precommand_example_names + ' ' + @value_example_names
    end

    if @application.begin_command == nil
      @application.begin_command=''
    end

    if @application.end_command == nil
      @application.end_command=''
    end

    @application.base_command = @application.begin_command + @precommand_base + ' '+@application.end_command
    @example_command =  @application.begin_command + @precommand_example + ' '+@application.end_command
    @example_command_names = @application.begin_command + @precommand_example_names + ' '+@application.end_command

    @application.save





  end

  def update
    @application = Application.find(params[:id])

    if params[:update_command]

      @new_params = params["application"]

      @begin= @new_params["begin_command"]
      @end= @new_params["end_command"]

      @application.begin_command = @begin
      @application.end_command = @end

      respond_to do |format|
        if @application.save
          format.html { redirect_to organize_parameters_path(@application), notice: 'Application was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end

    elsif params[:back]


      respond_to do |format|

        format.html { redirect_to add_inputs_path(@application), notice: '' }
        format.json { render json: @application, status: :created, location: @application}

      end

    elsif params[:finish]

      respond_to do |format|

        format.html { redirect_to @application, notice: '' }
        format.json { render json: @application, status: :created, location: @application}

      end

    else

      respond_to do |format|

        format.html { redirect_to add_inputs_path(@application), notice: 'Update the inputss of your application' }
        format.json { render json: @application, status: :created, location: @application}

      end

    end





  end

  def decrease_position_parameter

    puts 'DECREASE POSITION PARAMETER:'

    @application = Application.find(params[:application_id])
    @input = Input.find(params[:input_id])

    puts 'input actual antes'
    puts @input.name
    puts @input.position



    # si es el primer input no hago nada
    if @input.id != @application.inputs.order('position asc').first.id
      #debo encontrar el input anterior
      @posInputAnterior = @input.position-1

      @inputAnterior = @application.inputs.where('position=?',@posInputAnterior)[0]


      puts 'input anterior antes '
      puts @inputAnterior.name
      puts @inputAnterior.position

      #acá los intercambio
      @input.position =  @input.position-1
      @inputAnterior.position =  @inputAnterior.position+1

      puts 'input actual despues'
      puts @input.name
      puts @input.position

      puts 'input anterior despues '
      puts @inputAnterior.name
      puts @inputAnterior.position

      #acá los grabo
      respond_to do |format|
        if @application.save and   @input.save and @inputAnterior.save
          format.html { redirect_to organize_parameters_path(@application), notice: 'Application was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.html { redirect_to organize_parameters_path(@application), notice: 'There was an error' }
        format.json { head :no_content }
      end
    end







  end

  def increase_position_parameter

    @application = Application.find(params[:application_id])
    @input = Input.find(params[:input_id])

    # si es el ultimo input no hago nada
    if @input.id != @application.inputs.order('position asc').last.id
      #debo encontrar el input anterior
      @posInputSiguiente = @input.position+1

      @inputSiguiente = @application.inputs.where('position=?',@posInputSiguiente)[0]

      puts 'XXXXXXXXXXXXXXXXXXXXXX'
      puts 'pos input actual'
      puts @input.position
      puts 'pos input anterior'
      puts @posInputSiguiente

      #acá los intercambio
      @input.position =  @input.position+1
      @inputSiguiente.position =  @inputSiguiente.position-1

      #acá los grabo
      respond_to do |format|
        if @application.save and   @input.save and @inputSiguiente.save
          format.html { redirect_to organize_parameters_path(@application), notice: 'Application was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @application.errors, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.html { redirect_to organize_parameters_path(@application), notice: 'There was an error' }
        format.json { head :no_content }
      end
    end






  end

end
