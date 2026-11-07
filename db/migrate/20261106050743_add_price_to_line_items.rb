class AddPriceToLineItems < ActiveRecord::Migration[8.1]
  def change
    add_column :line_items, :price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
