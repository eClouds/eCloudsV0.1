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
end