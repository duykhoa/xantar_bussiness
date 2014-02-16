class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :factual_id, presense: true
      t.text :content

      t.timestamps
    end
  end
end
