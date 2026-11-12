class RemoveDescriptionFromProducts < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :description, :text
  end
end
