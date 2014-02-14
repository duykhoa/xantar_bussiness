class BussinessesController < ApplicationController
  before_action :factual_authorize, only: [:index, :search]

  def index
    @results = []
  end

  def search
    query = @factual.table('places')
    query = query.filters('locality' => params[:place].strip) unless params[:place].blank?

    @results = fatual_results(query).first

    respond_to do |format|
      format.html { render 'index' }
    end
  end

  private
    def factual_authorize
      @factual = Factual.new(Settings.factual.key, Settings.factual.secret)
    end

    def fatual_results query
      query_by_category = query.filters('category_labels' => params[:query].strip) unless params[:query].blank?
      query_by_place_name = query.search(params[:query].strip)

      [query_by_category.rows + query_by_place_name.rows].uniq { |item| item['factual_id'] }
    end
end
