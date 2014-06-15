class ClustersController < ApplicationController
  # GET /clusters
  # GET /clusters.json
  def index



    @clusters = Cluster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clusters }
    end
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show

    @cluster = Cluster.find(params[:id])

    #ClustersHelper.current_cluster=(@cluster)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cluster }
    end
  end

  # GET /clusters/new
  # GET /clusters/new.json
  def new
    @cluster = Cluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cluster }
    end
  end

  # GET /clusters/1/edit
  def edit
    @cluster = Cluster.find(params[:id])
  end

  # POST /clusters
  # POST /clusters.json
  def create
    @cluster = Cluster.new(params[:cluster])
    @cluster.user_id = current_user.id

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to @cluster, notice: 'Cluster was successfully created.' }
        format.json { render json: @cluster, status: :created, location: @cluster }
      else
        format.html { render action: "new" }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clusters/1
  # PUT /clusters/1.json
  def update
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        format.html { redirect_to @cluster, notice: 'Cluster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1
  # DELETE /clusters/1.json
  def destroy
    @cluster = Cluster.find(params[:id])
    @cluster.destroy
    @cluster.virtual_machines.destroy

    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :no_content }
    end
  end

  def add_virtual_machines

    @ec2 = Aws::Ec2.new(AMAZON_ACCESS_KEY_ID_EC2, AMAZON_SECRET_ACCESS_KEY_EC2)

    @cluster = Cluster.find(params[:id])
    @number_of_vms = params["vms_number_input" ]
    @number_of_vms = @number_of_vms[:vm_number].to_i
    #@number_of_vms =5


    @instance_type = @cluster.instance_type
    #puts "hola!!!!!!!"
    #puts @cluster.name
    #puts @number_of_vms

       # falta coger info dependiendo del tipo de vm
    for i  in 1..@number_of_vms

      @instances = @ec2.launch_instances( ENV["AMI_APP_CIENTIFICAS_NAME"] ,:group_ids => [ENV["SECURITY_GROUP"]],
                                          :instance_type => @instance_type ,
                                          :user_data => 'EClouds Instance',
                                          :key_name => ENV["KEY_PAIR_NAME"])
      @instance = @instances[0]

      #@name =  (0..4).map{(65.+rand(25)).chr}.join
      @name = @instance[:aws_instance_id]

      @virtual_machine = VirtualMachine.new
      @virtual_machine.AMI_name = @name
      @virtual_machine.hostname = 'pending'
      puts 'obteniendo nombre de la vm'
      puts @virtual_machine.AMI_name
      @virtual_machine.slots = 1

      ## acá cojo el estado de la mv

      @virtual_machine.cluster_id = @cluster.id

      puts @virtual_machine.cluster_id
      @virtual_machine.save

      @event = VirtualMachineEvent.new

      @event.action = VIRTUAL_MACHINE_EVENTS[:CREATED]
      @event.vm_id = @virtual_machine.id
      @event.user_id = current_user.id
      @event.save

    end
      respond_to do |format|
       format.html { redirect_to @cluster, notice: 'Cluster was successfully updated.' }
       end
  end



end
