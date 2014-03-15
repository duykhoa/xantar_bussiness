class AddPlaceInPromotion < ActiveRecord::Migration
  def change
    add_column :promotions, :place, :string
  end
end
