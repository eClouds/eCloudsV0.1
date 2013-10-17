class RegistrationsController < Devise::RegistrationsController

  def create
    super
    # Cada vez que creo un un usuario le pongo su directorio raiz y el Demo Results
    @root_dir = Directory.new
    @root_dir.name = ""
    @root_dir.directory_path =  "/"
    @root_dir.user_id = resource.id
    @root_dir.save


    @demo_dir = Directory.new
    @demo_dir.name = "Demo Results"
    @demo_dir.parent_id = @root_dir.id
    @demo_dir.user_id = resource.id
    @demo_dir.save



  end


end
