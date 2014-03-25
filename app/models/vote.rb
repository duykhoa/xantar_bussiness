class Vote < ActiveRecord::Base

  MAX_PROMOTIONS_PER_VOTE = 10

  belongs_to :vote

  default_scope order("created_at DESC")

  def self.last_votes_factual_ids query, place
    self.where("LOWER(query) LIKE '%#{query.downcase}%' AND LOWER(place) = '#{place.downcase}'").map(&:factual_id).uniq
  end

  before_save :exist_another_live_vote

  def exist_another_live_vote
    another_vote = Vote.find_by_id factual_id
    another_vote.present? || another_vote.promotions.count < MAX_PROMOTIONS_PER_VOTE
  end
end
