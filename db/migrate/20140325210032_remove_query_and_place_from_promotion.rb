class RemoveQueryAndPlaceFromPromotion < ActiveRecord::Migration
  def up
    remove_column :promotions, :query
  end

  def down
    remove_column :promotions, :place
  end
end
