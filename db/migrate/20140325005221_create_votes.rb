class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :factual_id

      t.timestamps
    end
  end
end
