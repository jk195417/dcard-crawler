namespace :antusd do
  desc '取得留言的文字向量'
  task load: :environment do
    require 'csv'
    dic_path = 'lib/ANTUSD/opinion_words.csv'
    puts '****************************************'
    puts "Loading opinion words from #{dic_path}"
    columns = %i[word score positive neutral negative non_opinionated not_a_word]
    values = CSV.read Rails.root.join(dic_path)
    OpinionWord.import! columns, values
    puts 'Task done!'
    puts '****************************************'
  end

  task reload: :environment do
    require 'csv'
    dic_path = 'lib/ANTUSD/opinion_words.csv'
    puts '****************************************'
    puts 'Reloading opinion words'
    puts 'Delete all opinion words'
    OpinionWord.delete_all
    puts "Loading opinion words from #{dic_path}"
    columns = %i[word score positive neutral negative non_opinionated not_a_word]
    values = CSV.read Rails.root.join(dic_path)
    OpinionWord.import! columns, values
    puts 'Task done!'
    puts '****************************************'
  end
end
