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
        },
      ]

      country = Country.find_country_by_name(places)
      params << {'country' => country.alpha2.downcase} if country

      params
    end

    def query_by_place query, places
      query.filters({
        '$or' => params_for_place(places)
      })
    end

    def query_by_name query, name
      query.filters({
        '$or' => [
          {
            'category_labels' => name
          },
          {
            'name' =>
              {'$search' => name}
          }
        ]
      })
    end

    def build_fatual_query query, params
      a_query = query
      a_query = query_by_place(query, params[:place].strip) if params[:place].present?
      a_query = query_by_name(a_query, params[:query].to_s.strip) if params[:query].present?

      a_query
    end
  end
end
