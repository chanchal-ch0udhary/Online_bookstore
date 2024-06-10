class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.decimal :price
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
