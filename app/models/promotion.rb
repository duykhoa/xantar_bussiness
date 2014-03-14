class Promotion < ActiveRecord::Base
  def self.promotion_count_by_factual_id factual_id
    self.where(factual_id: factual_id).count
  end

  def self.promoted_factual_ids query
    self.where("query LIKE '%#{query}%'").map(&:factual_id).uniq
  end

  before_save :promotion_less_than_10

  def promotion_less_than_10
    self.class.promotion_count_by_factual_id(self.factual_id) < 10
  end
end
