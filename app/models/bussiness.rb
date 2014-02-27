class Bussiness < ActiveRecord::Base
  require 'open-uri'
  require 'json'

  def self.zip_code_or_place_name places_params
    places_params.to_i > 0 ? find_city_by_zipcode(places_params) : places_params rescue {"$blank" => false}
  end

  def self.fatual_results query, params
    place = zip_code_or_place_name params[:place].strip

    query = query.filters('locality' => place) unless params[:place].blank?

    query_by_category = query.filters('category_labels' => params[:query].strip) unless params[:query].blank?
    query_by_place_name = query.search(params[:query].strip)

    category_rows = query_by_category.rows if query_by_category

    [category_rows.to_a + query_by_place_name.rows].uniq { |item| item['factual_id'] }
  end

  def self.find_city_by_zipcode zipcode
    JSON.parse(open("https://s3.amazonaws.com/zips.dryan.io/#{zipcode}.json").read)["locality"]
  end
end
