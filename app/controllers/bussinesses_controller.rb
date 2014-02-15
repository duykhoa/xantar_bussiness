class BussinessesController < ApplicationController
  before_action :factual_authorize, only: [:index, :search]

  def index
    @results = []
  end

  def search
    query = @factual.table('places')
    @results = Bussiness.fatual_results(query, params).first

    respond_to do |format|
      format.html { render 'index' }
    end
  end

  private
    def factual_authorize
      @factual = Factual.new(Settings.factual.key, Settings.factual.secret)
    end
end
