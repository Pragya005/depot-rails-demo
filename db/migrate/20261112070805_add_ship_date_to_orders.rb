class AddShipDateToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :ship_date, :date
  end
end
