class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  def total_price
    product.price * quantity
  end

  def change_quantity(amount)
    if quantity + amount >= 1
      self.quantity += amount
    else
      self.destroy
    end
  end
end
