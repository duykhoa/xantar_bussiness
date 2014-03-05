class BussinessesController < ApplicationController
  before_action :factual_authorize, only: [:index, :search, :show]

  def index
    @results = []
  end

  def search
    query = @factual.table('places')
    @results, @total_results = Bussiness.factual_results(query, params)

    respond_to do |format|
      format.html { render 'index' }
    end
  end

  def show
    query = @factual.table('places')
    @bussiness = query.filters('factual_id' => params[:id]).first
    @comments = Comment.find_all_by_factual_id @bussiness['factual_id']

    other_bussiness @bussiness
  end

  private

  def other_bussiness bussiness
    factual_query bussiness

    response = @factual.multi(
      hotels_us_query: @hotels_us_query,
      restaurants_us_query: @restaurants_us_query,
      healthcare_providers_us_query: @healthcare_providers_us_query)

    @addition_info = response.select { |key, value| value.count > 0 }.first
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
end
