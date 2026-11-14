class Product < ApplicationRecord
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }
  validates :title, :description, :image, presence: true
  validates :price, numericality: { greater_than: 0, if: -> { price.present? } }
  validates :title, uniqueness: true, length: { minimum: 10, message: "must be at least 10 characters long" }
  validate :acceptable_image
  has_rich_text :description
  validates :permalink, uniqueness: true, format: { with: /\A[A-Za-z0-9]+(?:-[A-Za-z0-9]+){2,}\z/ }, allow_nil: true
  validate :description_word_count
  after_initialize :set_default_title
  before_save :set_discount_price
  # price non-custom validator
  # validates :price, comparison: { greater_than: :discount_price, if: -> { price.present? && discount_price.present? } }

  # custom validator
  validate :discount_price_less_than_price
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  private def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, "Line Items present")
      throw :abort
    end
  end

  private def set_default_title
    self.title = "abc" unless title.present?
  end

  private def set_discount_price
    self.discount_price = price if discount_price.blank?
  end

  def acceptable_image
    return unless image.attached?

    acceptable_types = [ "image/jpeg", "image/png", "image/gif" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG, PNG, or GIF")
    end
  end

  def description_word_count
    len = description.to_plain_text.split.count
    if len < 5 || len > 10
      errors.add(:description, "description length should be < 5 and > 10")
    end
  end

  def discount_price_less_than_price
    if price.present? && discount_price.present? && price < discount_price
      errors.add(:base, "discount price cannot be more than price")
    end
  end
end
