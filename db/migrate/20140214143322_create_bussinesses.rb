class CreateBussinesses < ActiveRecord::Migration
  def change
    create_table :bussinesses do |t|

      t.timestamps
    end
  end
end
