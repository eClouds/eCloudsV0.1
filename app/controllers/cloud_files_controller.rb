class CloudFilesController < ApplicationController

  before_filter :auth_user!


  def auth_user!(opts = {})
    if :admin_user_signed_in?
      :authenticate_admin_user!
    else
      :authenticate_user!
    end
  end
  # GET /cloud_files
  # GET /cloud_files.json
  def index

    #load current_user's folders
    @directories = current_user.directories.order("name desc")

    @cloud_files = current_user.cloud_files.order("name desc")
    # este es para crear un archivo nuevo en el form
    @cloud_file = CloudFile.new

    ## para subir archivos en S3
    @uploader = CloudFile.new.avatar

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cloud_files }
    end
  end

  # GET /cloud_files/1
  # GET /cloud_files/1.json
  def show
    @cloud_file = current_user.cloud_files.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cloud_file }
    end
  end

  # GET /cloud_files/new
  # GET /cloud_files/new.json
  def new

    @cloud_file = CloudFile.new
    if params[:directory_id] #if we want to upload a file inside another folder
      @current_directory = current_user.directories.find(params[:directory_id])
      @cloud_file.directory_id = @current_directory.id
    end
    #@uploader.success_action_redirect = cloud_files_url

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cloud_file }
    end
  end

  # GET /cloud_files/1/edit
  def edit
    @cloud_file = current_user.cloud_files.find(params[:id])
  end

  # POST /cloud_files
  # POST /cloud_files.json
  def create


    @cloud_file = CloudFile.new(params[:cloud_file])

    
    @current_directory = session[:current_dir_session]
    if(@current_directory != nil)
      @cloud_file.directory_id = @current_directory.id
    end
  


    @cloud_file.user_id = current_user.id

    

    puts 'Holaaaaa'
    puts @cloud_file.attributes

    @cloud_file.url =@cloud_file.avatar.store_dir.to_s
    puts @cloud_file.url
    @cloud_file.name = @cloud_file.avatar.filename.to_s
    @cloud_file.size = @cloud_file.avatar.file.size


    #@upload = params["file_up" ]
    #puts @upload
    # para guardar archivos en el servidor
    #name=@upload[:data].original_filename
    #directory = "public/data"
    # create the file path
    #path = File.join(directory,name)
    # write the file
    #File.open(path,"wb"){ |f| f.write(@upload[:data].read)}

    if @cloud_file.save

      @cloud_file.url = @cloud_file.url + @cloud_file.id.to_s + "/" + @cloud_file.name
     puts  @cloud_file.url


      @cloud_file.save

      flash[:notice] = "Successfully uploaded the file."

      if @cloud_file.directory #checking if we have a parent folder for this file
        redirect_to browse_path(@cloud_file.directory)  #then we redirect to the parent folder
      else
        redirect_to data_home_path
      end
    else
      render :action => 'new'
    end

    puts @cloud_file



  end

  # PUT /cloud_files/1
  # PUT /cloud_files/1.json
  def update
    @cloud_file = current_user.cloud_files.find(params[:id])

    respond_to do |format|
      if @cloud_file.update_attributes(params[:cloud_file])
        format.html { redirect_to @cloud_file, notice: 'Cloud file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cloud_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_files/1
  # DELETE /cloud_files/1.json
  def destroy

    @cloud_file = current_user.cloud_files.find(params[:id])
    @parent_directory = @cloud_file.directory
    @cloud_file.destroy



    flash[:notice] = "Successfully deleted the file."

    #redirect to a relevant path depending on the parent folder
    if @parent_directory
      redirect_to browse_path(@parent_directory)
      puts 'Voy a redireccionar al parent:'
      puts @parent_directory.name
    else
      redirect_to data_home_path
    end


  end

   # para guardar archivos en el servidor
   #def self.save(upload)
   # name=upload['datafile'].original_filename
   # directory = "public/data"
    # create the file path
    # path = File.join(directory,name)
    # write the file
    #  File.open(path,"wb"){ |f| f.write(upload['datafile'].read)}
    #end


end
