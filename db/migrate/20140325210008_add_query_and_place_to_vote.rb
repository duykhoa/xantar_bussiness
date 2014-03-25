class AddQueryAndPlaceToVote < ActiveRecord::Migration
  def change
    add_column :votes, :query, :string
    add_column :votes, :place, :string
  end
end
