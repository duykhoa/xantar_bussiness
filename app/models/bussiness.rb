class Bussiness < ActiveRecord::Base
  class << self
    def factual_results query, params
      query = build_fatual_query query, params
      page = params[:page] || '1'

      [
        query.select('name', 'region', 'country', 'locality', 'address', 'factual_id', 'tel', 'category_labels', 'neighborhood', 'website').
          page(page, per: Places::FREE_ACC_QUERY_LIMIT).rows,
        (query.total_count.to_f/Places::FREE_ACC_QUERY_LIMIT).ceil
      ]
    end

    def params_for_place places
      params = [
        {'postcode' => places},
        {'region' =>
            {'$search' => places}
        },
        {
          'locality' =>
            {'$search' => places}
        },
        {
          'neighborhood' =>
            {'$search' => places}
        },
        {
          'address' =>
            {'$search' => places}
        }
      ]

      country = Country.find_country_by_name(places)
      params << {'country' => country.alpha2} if country

      params
    end

    def query_by_place places
      {
        '$or' => params_for_place(places)
      }
    end

    def query_by_name name
      {
        '$or' => [
          {
            'category_labels' => name
          },
          {
            'name' =>
              {'$search' => name}
          }
        ]
      }
    end

    def factual_params params
      if params[:place].present? && params[:query].present?
        {
          '$and' => [
            query_by_place(params[:place].strip),
            query_by_name(params[:query].strip)
          ]
        }
      elsif params[:place].present?
        query_by_place(params[:place].strip)
      elsif params[:query].present?
        query_by_name(params[:query].strip)
      else
        {}
      end
    end

    def build_fatual_query query, params
      query.filters factual_params(params)
    end
  end
end
