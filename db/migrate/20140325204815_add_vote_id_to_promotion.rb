class AddVoteIdToPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :vote_id, :integer
  end
end
