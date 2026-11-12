class AddPaymentDetailsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :routing_number, :string
    add_column :orders, :account_number, :string
    add_column :orders, :card_no, :string
    add_column :orders, :expiration_date, :date
    add_column :orders, :po, :string
  end
end
