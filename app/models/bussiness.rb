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

    def partial_params place
      [
        {'region' =>
            {'$search' => place}
        },
        {
          'locality' =>
            {'$search' => place}
        },
        {
          'neighborhood' =>
            {'$search' => place}
        },
        {
          'address' =>
            {'$search' => place}
        }
      ]
    end

    def places_params places
      params = [{'postcode' => places}]
      params.concat partial_params places
      places.split(',').each { |place| params.concat partial_params place }

      params
    end

    def params_for_place places
      params =  places_params places
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

    def build_params_for_approximately_search bussiness
      {
       'name' =>  bussiness['name'],
       'latitude' =>  bussiness['latitude'],
       'longitude' =>  bussiness['longitude'],
       'tel' =>  bussiness['tel'],
       'website' => bussiness['website']
      }
    end
  end
end
