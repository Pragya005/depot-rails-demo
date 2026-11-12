class AddLocaleToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :locale, :string, default: I18n.default_locale, null: false
  end
end
