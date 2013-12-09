# -*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require "net/http"
require "uri"

class Keyword_Generate
  
  module KeywordSetting
    BASE_URL = "http://hanyu.iciba.com/zt/3500.html"
    SPECIAL_DIGITAL = ["1","2","3","4","5","6","7","8","9","0"]
    SPECIAL_CHARS = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
  end
  
  def save_keywords()
    get_words_in_pages(get_doc(KeywordSetting::BASE_URL))
    save_special_chars(KeywordSetting::SPECIAL_DIGITAL)
    save_special_chars(KeywordSetting::SPECIAL_CHARS)
  end

  def get_doc(url)
    charset = "utf-8"
    begin
       return Nokogiri::HTML(open(url),nil,charset)
    rescue OpenURI::HTTPError
      puts "doc not found while openning uri"
      return nil
    rescue Errno::ETIMEDOUT
      puts "timeout occured at open uri"
      return nil
    rescue Errno::ENETUNREACH
      puts "network problem occured at open uri"
      return nil
    rescue Exception => details
      puts "error occured at open uri"
      puts details
      return nil
    end
  end

  def get_words_in_pages(doc)
    word_htmls = doc.css('a[href]')
    count = 0
    word_htmls.each do |word_html|
      if word_html.text.size==1
         search_keyword = SearchKeyword.new
         search_keyword.keyword =word_html.text
         search_keyword.word_frequency=1      
         search_keyword.search_count= 0
         search_keyword.save
         count += 1
      end
    end
    puts count
  end
  
  def save_special_chars(chars)
    count = 0
    chars.each do |char|
      search_keyword = SearchKeyword.new
      search_keyword.keyword =char
      search_keyword.word_frequency=1      
      search_keyword.search_count= 0
      search_keyword.save
      count += 1
    end
    puts count
  end
  def initialize_keyword_frequency()
    SearchKeyword.all.each do |keyword|
     keyword.word_frequency=1
     keyword.save
    end
  end
  def create_keyword_frequency()
    UserinfoFromSearch.all.each do |search|
      search['screen_name'].each_char do |char|
        temp_keyword = SearchKeyword.find_by_keyword(char)
        if !temp_keyword.nil?
          temp_keyword.word_frequency +=1
          temp_keyword.save
        else
         temp_keyword = SearchKeyword.new
         temp_keyword.keyword =char
         temp_keyword.word_frequency=1      
         temp_keyword.search_count= 0
         temp_keyword.save
        end
        puts temp_keyword 
        puts temp_keyword.word_frequency
      end
    end
  end
end


