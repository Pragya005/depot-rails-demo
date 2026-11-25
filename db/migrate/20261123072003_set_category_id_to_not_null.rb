class SetCategoryIdToNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :products, :category_id, false
  end
end
