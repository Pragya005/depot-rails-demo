class LineItem < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true, counter_cache: :saman_counter
  validates :product_id, uniqueness: { scope: :cart_id, if: -> { cart_id.present? } }

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
