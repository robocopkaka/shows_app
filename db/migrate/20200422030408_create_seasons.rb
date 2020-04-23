class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.string :title, null: false
      t.string :plot, null: false
      t.integer :number, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :seasons, [:title, :number], unique: true
  end
end
