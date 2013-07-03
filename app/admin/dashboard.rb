ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do


    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
    column do
         panel "Recent Executions" do
           table do
             tr do
               th "Execution Name"
               th "Created at"
               th "Created by"
             end
             Execution.all( :order => "created_at desc", :limit => 10).each do |execution|
               tr do
                 td link_to(execution.name, execution)
                 td execution.created_at
                 td  execution.user.email
                 end
             end
           end
         end
       end

       column do
         panel "Users" do
           table do
             tr do
               th "Event description"
               th "Created at"
             end
             Event.all(:order => "created_at desc", :limit => 10).each do |event|
               tr do
                 td event.description
                 td event.created_at
               end
             end
           end
         end
       end
     end
  end # content
end
