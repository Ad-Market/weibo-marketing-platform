class AddReultCountToSearchKeywords < ActiveRecord::Migration
  def change
    add_column :search_keywords, :result_count, :integer
    add_column :search_keywords, :search_url, :string
    add_column :search_keywords, :url_type, :integer
  end
end
