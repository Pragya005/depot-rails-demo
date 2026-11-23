class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.references :parent, foreign_key: { to_table: :categories }, index: true
      t.timestamps
      t.index :name, unique: true, where: "parent_id is NULL", name: "unique_root_category_names"
      t.index [ :name, :parent_id ], unique: true, where: "parent_id is NOT NULL", name: "unique_sub_category_name_for_category"
    end
  end
end
