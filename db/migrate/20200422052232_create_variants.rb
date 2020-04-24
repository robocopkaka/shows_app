class CreateVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :variants do |t|
      t.string :quality, null: false
      t.float :cost, default: 2.99
      t.references :showable, polymorphic: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
