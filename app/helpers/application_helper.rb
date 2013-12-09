module ApplicationHelper
  def split_by_dollar(sentence)
    sentence = sentence.lstrip
    unless sentence.nil? || sentence.empty?
      return_array = sentence.split('$')
      return_array.delete("")
    else
      return_array = []
      return_array << sentence.to_s
    end
    return_array
  end

  def delete_dollar(sentence)
    sentence.nil?? nil : sentence.gsub('$','')
  end
end
