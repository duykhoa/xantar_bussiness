class Promotion < ActiveRecord::Base

  belongs_to :votes

  before_save :promotion_count_checking

  def promotion_count_checking
    vote = Vote.find_by_id vote_id
    vote.live_vote?
  end
end
