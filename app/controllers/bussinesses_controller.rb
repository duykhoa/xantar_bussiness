require 'open-uri'

class BussinessesController < ApplicationController
  before_action :factual_authorize, only: [:index, :search, :show]
  before_action :promoted_factual, only: :search

  def index
    @results = []
  end

  def search
    @results, @total_results = Bussiness.factual_results(@query, params)
    @results.sort_by! { |result| -Comment.find_all_by_factual_id(result['factual_id']).count }

    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def show
    query = @factual.table('places')
    @bussiness = query.filters('factual_id' => params[:id]).first
    @comments = Comment.find_all_by_factual_id @bussiness['factual_id']

    @vote = Vote.find_by_factual_id @bussiness['factual_id']

    @cat_url = cat_url_for_hotel

    alternate_id = alternate_bussiness_id

    if alternate_id
      @alternate_bussiness = query.filters('factual_id' => alternate_id).first
      Vote.impression @alternate_bussiness['factual_id']
    end
  end

  private
  def cat_url_for_hotel
    other_bussiness?(@bussiness) ? cat_url : ''
  end

  def cat_url
    begin
      Nokogiri::XML(open(Settings.cat_api.url)).css("url").text
    rescue Exception
      ''
    end
  end

  def other_bussiness? bussiness
    factual_query bussiness

    response = @factual.multi(
      hotels_us_query: @hotels_us_query,
      restaurants_us_query: @restaurants_us_query,
      healthcare_providers_us_query: @healthcare_providers_us_query)

    @addition_info = response.select { |key, value| value.count > 0 }.first

    display_cat_image response
  end

  def display_cat_image response
    response[:hotels_us_query].send(:response)["included_rows"] > 0 ||
    response[:restaurants_us_query].send(:response)["included_rows"] > 0
  end

  def factual_query bussiness
    %W(hotels-us restaurants-us healthcare-providers-us).each do |table|
      instance_variable_set "@#{table.underscore}_query",
        @factual.table(table).filters(
          Bussiness.build_params_for_approximately_search(bussiness))
    end
  end

  def factual_authorize
    @factual = Factual.new(Settings.factual.key, Settings.factual.secret)
  end

  def promoted_factual
    @query = @factual.table('places')
    @promoted_factual = Bussiness.promoted_factual params[:query], params[:place], @query
  end

  def alternate_bussiness_id
    votes_by_city = Vote.find_all_by_place(@bussiness['locality'])
    random_vote = votes_by_city
      .select { |vote| longest_common_substr([@bussiness['category_labels'], vote.query]) }
      .reject { |vote| vote.factual_id.eql?(@bussiness['factual_id']) || !vote.live_vote? }
      .sample
    random_vote.factual_id if random_vote
  end

  def longest_common_substr(strings)
    shortest = strings.min_by(&:length)
    maxlen = shortest.length
    maxlen.downto(0) do |len|
      0.upto(maxlen - len) do |start|
        substr = shortest[start,len]
        return substr if strings.all?{|str| str.include? substr }
      end
    end
  end
end
