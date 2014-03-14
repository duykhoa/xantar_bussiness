class CreatePromotion < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :factual_id
      t.string :query
    end
  end
end
