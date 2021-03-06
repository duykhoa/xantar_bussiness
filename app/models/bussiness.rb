class Bussiness < ActiveRecord::Base
  class << self
    def factual_results query, params
      query = build_fatual_query query, params

      # get 2 first page
      results_page_1 = query.select('name', 'region', 'country', 'locality', 'address', 'factual_id', 'tel', 'category_labels', 'neighborhood', 'website', 'longitude', 'latitude').
          page(1, per: Places::FREE_ACC_QUERY_LIMIT).rows

      results_page_2 = query.select('name', 'region', 'country', 'locality', 'address', 'factual_id', 'tel', 'category_labels', 'neighborhood', 'website', 'longitude', 'latitude').
          page(2, per: Places::FREE_ACC_QUERY_LIMIT).rows

      [
        results_page_1.concat(results_page_2),
        query.total_count
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
            'category_labels' =>
              {'$search' => name}
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
       'latitude' =>  bussiness['latitude'] || {"$blank" => true},
       'longitude' =>  bussiness['longitude'] || {"$blank" => true},
       'tel' =>  bussiness['tel'] || {"$blank" => true},
       'website' => bussiness['website'] || {"$blank" => true}
      }
    end

    def promoted_factual params_query, place, query
      promoted_factual_ids = Vote.promoted_factual_ids params_query, place
      promoted_factual_ids.reject! { |id| !Vote.find_by_factual_id(id).live_vote? }

      # Impression every factual_id
      Vote.impression_list promoted_factual_ids
      query_params = promoted_factual_ids.inject([]) do |factual_params, id|
        factual_params << {"factual_id" => id}
      end

      if query_params.count > 0
        query.select('name', 'region', 'country', 'locality', 'address', 'factual_id', 'tel', 'category_labels', 'neighborhood', 'website', 'longitude', 'latitude').
          filters({'$or' => query_params}).
          rows
      else
        []
      end
    end
  end
end
