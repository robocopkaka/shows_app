class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :plot, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :movies, :title, unique: true
  end
end
