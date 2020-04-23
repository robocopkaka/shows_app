class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.string :title, null: false
      t.string :plot
      t.integer :number
      t.references :season, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :episodes, [:title, :season_id], unique: true
  end
end
