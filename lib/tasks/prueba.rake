namespace :llenar do
task :prueba => :environment do

  SelectedItem.create(:name => "nt", :value=> 'nt.gz').save
  SelectedItem.create(:name => "nr", :value=> 'nr.gz').save
  SelectedItem.create(:name => "alu.a", :value=> 'alu.a.gz').save
  SelectedItem.create(:name => "alu.n", :value=> 'alu.n.gz').save
  SelectedItem.create(:name => "drosoph.aa", :value=> 'drosoph.aa.gz').save
  SelectedItem.create(:name => "env_nr", :value=> 'env_nr.gz').save
  SelectedItem.create(:name => "env_nt", :value=> 'env_nt.gz').save
  SelectedItem.create(:name => "est_human", :value=> 'est_human.gz').save

end
  task :usuarios => :environment do
    for i in 50..50 do

      user = User.new email: 'taller-'+i.to_s+'@uniandes.edu.co', password: 'taller'+i.to_s, password_confirmation: 'taller'+i.to_s
      user.approved=true
      user.confirmed_at='2014-04-09'
      user.confirmation_sent_at='2014-04-09'
      user.save


    end
  end

  task :crear_ec2 => :environment do

    @ec2 = Aws::Ec2.new(AMAZON_ACCESS_KEY_ID_EC2, AMAZON_SECRET_ACCESS_KEY_EC2)
    file = File.open(Rails.root+"boot.sh","rb")
    contents = file.read
    user_data = Base64.encode64(contents)
    file.close

    @instances = @ec2.launch_instances( AMI_APP_CIENTIFICAS_NAME, :group_ids => [SECURITY_GROUP],
                                        :instance_type => "t1.micro" ,
                                        :user_data => Rails.env.to_s,
                                        :key_name => KEY_PAIR_NAME
                                        )

  end

  task :crear_conditionals => :environment do

    @conditional = Conditional.new(:value => "Custom")

    @conditional.input_id_pre= 277
    @conditional.input_id_post = 278
    @conditional.save

  end

task :crear_selectedItems_MXP => :environment do

  SelectedItem.create(:name => "bio_1.asc", :value=> 'bio_1.asc').save
  SelectedItem.create(:name => "bio_2.asc", :value=> 'bio_2.asc').save
  SelectedItem.create(:name => "bio_3.asc", :value=> 'bio_3.asc').save
  SelectedItem.create(:name => "bio_4.asc", :value=> 'bio_4.asc').save
  SelectedItem.create(:name => "bio_5.asc", :value=> 'bio_5.asc').save
  SelectedItem.create(:name => "bio_6.asc", :value=> 'bio_6.asc').save
  SelectedItem.create(:name => "bio_7.asc", :value=> 'bio_7.asc').save
  SelectedItem.create(:name => "bio_8.asc", :value=> 'bio_8.asc').save
  SelectedItem.create(:name => "bio_9.asc", :value=> 'bio_9.asc').save
  SelectedItem.create(:name => "bio_10.asc", :value=> 'bio_10.asc').save
  SelectedItem.create(:name => "bio_11.asc", :value=> 'bio_11.asc').save
  SelectedItem.create(:name => "bio_12.asc", :value=> 'bio_12.asc').save
  SelectedItem.create(:name => "bio_13.asc", :value=> 'bio_13.asc').save
  SelectedItem.create(:name => "bio_14.asc", :value=> 'bio_14.asc').save

  SelectedItem.create(:name => "autofeature", :value=> 'autofeature').save
  SelectedItem.create(:name => "linear", :value=> 'linear').save
  SelectedItem.create(:name => "cuadratic", :value=> 'cuadratic').save
  SelectedItem.create(:name => "hinge", :value=> 'hinge').save
  SelectedItem.create(:name => "threshold", :value=> 'threshold').save
  SelectedItem.create(:name => "product", :value=> 'product').save

  SelectedItem.create(:name => "none", :value=> 'none').save
  SelectedItem.create(:name => "extrapolate", :value=> 'extrapolate').save
  SelectedItem.create(:name => "doclamp", :value=> 'doclamp').save

  SelectedItem.create(:name => "Minimum Training presence", :value=> 'Minimum Training presence').save
  SelectedItem.create(:name => "Ten percentile training presence", :value=> 'Ten percentile Training presence').save
  SelectedItem.create(:name => "Equal Sensitivity + Specificity", :value=> 'Equal Sensitivity + Specificity').save
  SelectedItem.create(:name => "Custom", :value=> 'Custom').save


  SelectedItem.create(:name => "True", :value=> 'True').save
  SelectedItem.create(:name => "False", :value=> 'False').save
  SelectedItem.create(:name => "True", :value=> 'True').save
  SelectedItem.create(:name => "False", :value=> 'False').save
  SelectedItem.create(:name => "True", :value=> 'True').save
  SelectedItem.create(:name => "False", :value=> 'False').save

end

task :crear_selectedItems_background => :environment do

  SelectedItem.find_all_by_state("En Proceso")


  SelectedItem.create(name:"Extent", value:"extent").save
  SelectedItem.create(name:"Regions", value:"regions").save
  SelectedItem.create(name:"ch", value:"ch").save

  SelectedItem.create(name:"Random", value:"random").save
  SelectedItem.create(name:"samples", value:"samples").save


  Conditional.create(input_id_pre:280,input_id_post:281,value:"random" ).save
  Conditional.create(input_id_pre:280,input_id_post:282,value:"samples" ).save
  Conditional.create(input_id_pre:279,input_id_post:283,value:"regions" ).save
  Conditional.create(input_id_pre:279,input_id_post:284,value:"regions" ).save
  Conditional.create(input_id_pre:279,input_id_post:285,value:"ch" ).save




end

  task :prueba1 => :environment do

    string = "sudo R --no-save --args    INPUT0  INPUT1  INPUT2  INPUT3  INPUT4  INPUT5  INPUT6  INPUT7  INPUT8  INPUT9  INPUT10  INPUT11  INPUT12  INPUT13  INPUT14  INPUT15  INPUT16  INPUT17  INPUT18  INPUT19 < wrapperEclouds.R"
    pattern = "INPUT"+1.to_s
    print string.gsub(/\s*#{pattern}\s+/ , ' 2w ')

    print SelectedItem.find_all_by_input_id(183).to_json
  end


end
