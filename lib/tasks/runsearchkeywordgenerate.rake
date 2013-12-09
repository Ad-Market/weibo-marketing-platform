namespace :KeywordAnalyzer do

  desc "Run Keyword Generate"
  task :keywordgenerate => :environment do |t, args|
       generater = Keyword_Generate.new
       generater.save_keywords()
       puts 'OK'
  end

  desc "Update Word frequency"
  task :updatewordfrequency => :environment do |t, args|
       generater = Keyword_Generate.new
       generater.initialize_keyword_frequency()
       generater.create_keyword_frequency()
       puts 'OK'
  end
  
  desc "Import Word To Dic_Word table"
  task :importdicword => :environment do |t, args|
       File.open("lib/tasks/words.dic","r") do |file|
          index = 0
	  while line  = file.gets
              temp_dicword =DicWord.new
              temp_dicword.word = line.to_s
              temp_dicword.save
              index += 1
	      puts index.to_s if index%100 == 0
	  end
       end
       puts 'OK'
  end

end
