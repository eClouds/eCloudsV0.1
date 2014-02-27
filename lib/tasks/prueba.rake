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