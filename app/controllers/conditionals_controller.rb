class ConditionalsController < ApplicationController

  def create

    if params[:next]
      format.html { redirect_to organize_parameters_path(@application), notice: 'Input successfully added' }
      format.json { render json: @application, status: :created, location: @application}
    else

    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
     puts params[:input_id_pre]
    puts "<<<<<<<<<<<<aaaaaaaaaaaaaaaaaaa<<<<<<<<<<"
    @conditional = Conditional.create(params[:conditional])
    @conditional.save

    @application = Application.find(Input.find(@conditional.input_id_pre).application_id)

    redirect_to add_conditionals_inputs_path(@application)
    end
  end

  def add_conditionals_inputs

    @application = Application.find(params[:application_id])
    @precondition_inputs = @application.inputs.where(is_precondition: true)

    @conditional = Conditional.new

    @actual_conditionals = Conditional.joins('INNER JOIN inputs ON inputs.id = conditionals.input_id_pre').where('inputs.application_id=?', @application.id)

  end

end
