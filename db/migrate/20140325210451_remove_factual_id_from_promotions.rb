class RemoveFactualIdFromPromotions < ActiveRecord::Migration
  def change
    remove_columns :promotions, :factual_id
  end
end
