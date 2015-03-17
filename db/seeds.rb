# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Application.create(
    [
        {"base_command"=>"INPUT1 INPUT2", "begin_command"=>"sudo R --no-save --args", "description"=>"First Version of MxParallel", "end_command"=>"< log.R", "estimated_time"=>30, "image"=>{"url"=>nil, :thumb=>{"url"=>nil}}, "installation_url"=>nil, "installer_url"=>"https://s3.amazonaws.com/EcloudsProd/Apps/RHumboldt/installationmxparallel.sh", "name"=>"RhumboldtMxParallel", "version"=>"1.0", "vm_type"=>"t1.small"},
        {"base_command"=>"INPUT1  INPUT2 ", "begin_command"=>"./command-blastn", "description"=>"BLASTN programs search nucleotide databases using a nucleotide query.", "end_command"=>"", "estimated_time"=>20, "image"=>{"url"=>nil, :thumb=>{"url"=>nil}}, "installation_url"=>nil, "installer_url"=>"https://s3.amazonaws.com/EcloudsProd/Apps/blast/scriptinstalacionblastn", "name"=>"Blastn", "version"=>"2.2.28+", "vm_type"=>"t1.micro"},
        {"base_command"=>"INPUT1  INPUT2  INPUT3  INPUT4 < INPUT5 ", "begin_command"=>"R --no-save", "description"=>"Custom application of Maxent for Colombian species.", "end_command"=>"", "estimated_time"=>20, "image"=>{"url"=>nil, :thumb=>{"url"=>nil}}, "installation_url"=>nil, "installer_url"=>"https://s3.amazonaws.com/EcloudsProd/Apps/RHumboldt/scriptInstalacionR.txt", "name"=>"RHumboldtMaps", "version"=>"1.0", "vm_type"=>"t1.micro"},
        {"base_command"=>"sudo R --no-save --args   INPUT1  INPUT2  INPUT3  INPUT4  INPUT5  INPUT6  INPUT7  INPUT8  INPUT9  INPUT10  INPUT11  INPUT12  INPUT13  INPUT14  INPUT15  INPUT16  INPUT17  INPUT18 < wrapperEclouds.R", "begin_command"=>"sudo R --no-save --args ", "description"=>"Version of mxParallel.R for modeling species distributions on amazon web services.", "end_command"=>" < wrapperEclouds.R", "estimated_time"=>40, "image"=>{"url"=>nil, :thumb=>{"url"=>nil}}, "installation_url"=>nil, "installer_url"=>"https://s3.amazonaws.com/EcloudsProd/Apps/RHumboldt/installationmxparallel-1.1.sh", "name"=>"RhumboldtMxParallel", "version"=>"1.1", "vm_type"=>"t1.small"},
        {"base_command"=>"INPUT1  INPUT2 ", "begin_command"=>"./command-blastp", "description"=>"Blastp is a protein Search base", "end_command"=>"", "estimated_time"=>30, "image"=>{"url"=>nil, :thumb=>{"url"=>nil}}, "installation_url"=>nil, "installer_url"=>"https://s3.amazonaws.com/EcloudsProd/Apps/blast/scriptinstalacionblastp", "name"=>"Blastp", "version"=>"2.2.28+", "vm_type"=>"t1.micro"}]
)

blastn = Application.find_by_name("Blastn")
blastn.inputs.create(
    [
        {"cloud_file_id"=>nil,"description"=>"Database", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"database", "position"=>2, "prefix"=>"", "value"=>nil, "visible"=>true},
        {"cloud_file_id"=>12,"description"=>"File with Fasta Format, it is the query to do the search", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>true, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"query", "position"=>1, "prefix"=>"","value"=>"HumanGeneforboneglaProtein.fasta", "visible"=>true},
        {"cloud_file_id"=>nil,"description"=>"Output Format ", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Output Format", "position"=>3, "prefix"=>"", "value"=>nil, "visible"=>true},
        {"cloud_file_id"=>nil,"description"=>"Expected Value", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>false, "name"=>"Expected Value", "position"=>4, "prefix"=>"", "value"=>"10", "visible"=>true}
    ]
)

blastp = Application.find_by_name("Blastp")
blastp.inputs.create(
    [
        {"cloud_file_id"=>nil, "description"=>"Query for search", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"query", "position"=>1, "prefix"=>"", "value"=>"", "visible"=>true},
        {"cloud_file_id"=>nil, "description"=>"Output Format", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Output Format", "position"=>3, "prefix"=>"", "value"=>nil, "visible"=>true},
        {"cloud_file_id"=>nil, "description"=>"Expected Value", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>false, "name"=>"Expected Value", "position"=>4, "prefix"=>"", "value"=>"10", "visible"=>true},
        {"cloud_file_id"=>nil, "description"=>"Database", "directory_id"=>nil, "execution_id"=>nil,"is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"database", "position"=>2, "prefix"=>"", "value"=>"", "visible"=>true}
    ]
)

outputformat = blastp.inputs.find_by_description("Output Format")
outputformat.selected_items.create(
    [
        {"name"=>"Pairwise", "value"=>"0"},
        {"name"=>"Query anchored showing identities","value"=>"1"},
        {"name"=>"Query-anchored no identities", "value"=>"2"},
        {"name"=>"Flat query-anchored, showing identities", "value"=>"3"},
        {"name"=>"Flat query-anchored, no identities", "value"=>"4"},
        {"name"=>"Tabular", "value"=>"6"},
        {"name"=>"XML Blast output","value"=>"5"},
        {"name"=>"Tabular with Comments Lines", "value"=>"7"},
        {"name"=>"Text ASN.1","value"=>"8"},
        {"name"=>"Binary ASN.1", "value"=>"9"}
    ]

)

rhumboldtmxparallel1 = Application.where("name=? and version=?","RhumboldtMxParallel","1.0").first
rhumboldtmxparallel1.inputs.create(
    [
        {"cloud_file_id"=>nil, "description"=>"Species occurrences. Data.frame object with species names, longitude and latitude", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Occurrences", "position"=>1, "prefix"=>"", "value"=>"", "visible"=>true},
        {"cloud_file_id"=>nil, "description"=>"File with study area mask", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Area Mask", "position"=>2, "prefix"=>"", "value"=>"", "visible"=>true}
    ]
)

rhumboldtmxparallel2 = Application.where("name=? and version=?","RhumboldtMxParallel","1.1").first
rhumboldtmxparallel2.inputs.create(
    [
    {"cloud_file_id"=>nil, "description"=>"Species occurrences. Data.frame object with species names, longitude and latitude", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Occurrences", "position"=>1, "prefix"=>"", "value"=>"", "visible"=>true}, 
    {"cloud_file_id"=>nil, "description"=>"File with study area mask", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Area Mask", "position"=>2, "prefix"=>"", "value"=>"", "visible"=>true}, 
    {"cloud_file_id"=>nil, "description"=>"Layers for the distribution", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>true, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Layers", "position"=>3, "prefix"=>"", "value"=>"", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Maxent Features", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>true, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Maxent Features", "position"=>4, "prefix"=>"", "value"=>nil, "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Threshold distribution models", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>true, "is_selecteditem"=>true, "name"=>"Do Threshold ", "position"=>7, "prefix"=>"", "value"=>nil, "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Cut the models using an patch rule", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Cut models", "position"=>8, "prefix"=>"", "value"=>nil, "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Evaluate Model ", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Evaluate Model", "position"=>6, "prefix"=>"", "value"=>"TRUE", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Optimize regularization Value", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>true, "name"=>"Optimize regularization Value", "position"=>5, "prefix"=>"", "value"=>"FALSE", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Regularization multiplier.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Lambda", "position"=>19, "prefix"=>"", "value"=>"1", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"umber of folds for k-fold partitioning used in evaluation and regularization optimization.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Number of Folds", "position"=>20, "prefix"=>"","value"=>"10", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"File of shapes to convert into SpatialPolygons object, with the regions that will be used to define species background.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Regions", "position"=>13, "prefix"=>"", "value"=>"NULL", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Path to comma separated file containing background samples.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>true, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Sample background", "position"=>12, "prefix"=>"", "value"=>"NULL", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Numeric or character. If numeric, this will specify the percentiles at which models should be thresholded.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>true, "is_precondition"=>true, "is_selecteditem"=>true, "name"=>"Threshold", "position"=>17, "prefix"=>"","value"=>"", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Keyword that defines where background will be sampled from.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>true, "is_selecteditem"=>true, "name"=>"Background", "position"=>9, "prefix"=>"", "value"=>"extent", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Keyword that defines how the background will be sampled.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>true, "is_selecteditem"=>true, "name"=>"Background type", "position"=>10, "prefix"=>"","value"=>"random", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Number of Background samples.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Number background", "position"=>11, "prefix"=>"","value"=>"10000", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Field (column name) that defines the regions.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Field", "position"=>14, "prefix"=>"", "value"=>"", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Number in meters to be applied to convex polygons.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Buffer", "position"=>15, "prefix"=>"", "value"=>"", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Distance in meters, within which records are considered duplicates. Only one record is kept within dist. ", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Distance", "position"=>16, "prefix"=>"","value"=>"1000", "visible"=>true},
    {"cloud_file_id"=>nil, "description"=>"Custom percentiles for the Threshold. Comma Separated.", "directory_id"=>nil, "execution_id"=>nil, "is_directory"=>false, "is_file"=>false, "is_multiple_selecteditem"=>nil, "is_precondition"=>nil, "is_selecteditem"=>nil, "name"=>"Custom Percentiles", "position"=>18, "prefix"=>"", "value"=>"", "visible"=>true}
  ]
)
