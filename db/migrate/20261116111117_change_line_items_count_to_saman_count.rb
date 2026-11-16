class ChangeLineItemsCountToSamanCount < ActiveRecord::Migration[8.1]
  def change
    rename_column :carts, :line_items_count, :saman_counter
  end
end
