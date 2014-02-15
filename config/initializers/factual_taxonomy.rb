class FactualTaxonomy
  require 'json'
  attr_reader :taxonomies

  def initialize
    file_taxonomy = File.join(Rails.root, 'config', 'initializers', 'factual_taxonomy.json')

    File.open file_taxonomy, "r" do |file|
      results = JSON.load file
      @taxonomies = results.map { |k,v| v["labels"]["en"] }
    end
  end
end

Factual_Taxonomy = FactualTaxonomy.new