class Vote < ActiveRecord::Base

  MAX_PROMOTIONS_PER_VOTE = 9

  has_many :promotions

  before_save :not_exist_another_live_vote

  default_scope order("created_at DESC")

  def self.last_votes_factual_ids query, place
    self.where("LOWER(query) LIKE '%#{query.downcase}%' AND LOWER(place) = '#{place.downcase}'").map(&:factual_id).uniq
  end

  def not_exist_another_live_vote
    !exist_another_live_vote
  end

  def exist_another_live_vote
    another_vote = Vote.find_by_factual_id factual_id
    another_vote.present? && another_vote.live_vote?
  end

  def live_vote?
    promotions.count <= MAX_PROMOTIONS_PER_VOTE
  end

  def self.promoted_factual_ids query, place
    query.gsub!(',', '')
    self.where("LOWER(query) LIKE '%#{query.downcase}%' AND LOWER(place) = '#{place.downcase}'").map(&:factual_id).uniq
  end
end
