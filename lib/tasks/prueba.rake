task :prueba => :environment do

  s3 = Aws::S3.new(AMAZON_ACCESS_KEY_ID, AMAZON_SECRET_ACCESS_KEY)
  obj = s3.buckets['EcloudsStaging'].objects('output.txt')
  puts obj.content-length

end