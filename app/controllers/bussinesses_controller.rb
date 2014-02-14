class BussinessesController < ApplicationController
  before_action :factual_authorize, only: [:index, :search]

  def index
    @results = []
  end

  def search
    query = @factual.table('places')
    query = query.filters('locality' => params[:place].strip) unless params[:place].blank?
    query = query.search(params[:query].strip)

    @results = query.rows

    respond_to do |format|
      format.html { render 'index' }
    end
  end

  private
    def factual_authorize
      @factual = Factual.new(Settings.factual.key, Settings.factual.secret)
    end
end
