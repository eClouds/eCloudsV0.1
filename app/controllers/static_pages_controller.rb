class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @executions=Execution.find_all_by_user_id(current_user.id)
      puts 'Entrooooo'
      @date = Date.today

      @executions2 = Execution.where("end_date IS NOT NULL and start_date IS NOT NULL and start_date >= ?", @date) #and start_date > "+@date.to_s)
      @periodTotal = 0
      @computingTotal = 0
      @executions2.each do |exec|
        @computingTotal += exec.total_cost
      end
      @periodTotal += @computingTotal





      @directories = current_user.directories
      @fileSize=0
      @cloud_files =  current_user.cloud_files
      @cloud_files.each do |file|
      @fileSize += file.size
      end
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
    else
      @applications=Application.all
    end
  end

  def help
  end

  def about
  end

end
