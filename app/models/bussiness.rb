class Bussiness < ActiveRecord::Base

  def self.zip_code_or_place_name places_params
    places_params.to_i > 0 ? ZIP_CODE.find(places_params)['city'] : places_params rescue {"$blank" => false}
  end

  def self.fatual_results query, params
    place = zip_code_or_place_name params[:place].strip

    query = query.filters('locality' => place) unless params[:place].blank?

    query_by_category = query.filters('category_labels' => params[:query].strip) unless params[:query].blank?
    query_by_place_name = query.search(params[:query].strip)

    category_rows = query_by_category.rows if query_by_category

    [category_rows.to_a + query_by_place_name.rows].uniq { |item| item['factual_id'] }
  end
end
