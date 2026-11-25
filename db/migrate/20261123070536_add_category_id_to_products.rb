class AddCategoryIdToProducts < ActiveRecord::Migration[8.1]
  def change
    add_reference :products, :category, null: true, index: true, foreign_key: true
  end
end
