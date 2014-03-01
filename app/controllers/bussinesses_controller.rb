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
  end

  private
    def factual_authorize
      @factual = Factual.new(Settings.factual.key, Settings.factual.secret)
    end
end
