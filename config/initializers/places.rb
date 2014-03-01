class Places
  require 'factual'
  FREE_ACC_QUERY_LIMIT = 50
  FREE_ACC_ROW_LIMIT = 500

  attr_accessor :places, :neighborhoods
  def initialize
    factual = Factual.new Settings.factual.key, Settings.factual.secret

    localities = results factual.table('places').select('locality'), 'locality'
    neighborhoods = results factual.table('places').select('neighborhood'), 'neighborhood'

    @places = localities.uniq
    @neighborhoods =  neighborhoods.flatten.compact.uniq
  end

  private
  def results query, field
    results = []
    pages(query).times do |i|
      results.concat query.page(i+1, per: FREE_ACC_QUERY_LIMIT).rows.map { |result| result[field] }
    end

    results
  end

  def pages query
    pages = (query.total_count.to_f/FREE_ACC_QUERY_LIMIT).ceil
    limit_pages = FREE_ACC_ROW_LIMIT / FREE_ACC_QUERY_LIMIT

    pages > limit_pages ? limit_pages : pages
  end
end

PLACES = Places.new
