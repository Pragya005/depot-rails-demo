class Product < ApplicationRecord
  MAX_DESCRIPTION_LENGTH = 10
  MIN_DESCRIPTION_LENGTH = 5
  DEFAULT_NAME = "abc"

  has_one_attached :image
  has_rich_text :description
  has_many :line_items, dependent: :restrict_with_exception
  has_many :carts, through: :line_items
  belongs_to :category, counter_cache: true
  scope :enabled, -> { where(enabled: true) }

  validates :title, :description, :image, presence: true
  validates :price, numericality: { greater_than: 0, if: -> { price.present? } }
  validates :title, uniqueness: true, length: { minimum: 10, message: "must be at least 10 characters long" }
  validate :acceptable_image
  validates :permalink, uniqueness: true, format: { with: /\A[A-Za-z0-9]+(?:-[A-Za-z0-9]+){2,}\z/ }, allow_nil: true
  validate :description_word_count
  validate :discount_price_less_than_price
  # price non-custom validator
  # validates :price, comparison: { greater_than: :discount_price, if: -> { price.present? && discount_price.present? } }

  after_initialize :set_default_title
  before_save :set_discount_price
  after_commit -> { broadcast_refresh_later_to "products" }
  # before_destroy :ensure_not_referenced_by_any_line_item

  # private def ensure_not_referenced_by_any_line_item
  #   unless line_items.empty?
  #     errors.add(:base, "Line Items present")
  #     throw :abort
  #   end
  # end

  def self.products_in_atleast_one_line_item
    joins(:line_items).distinct
  end

  # def self.title_of_products_in_atleast_one_line_item
  #   joins(:line_items).distinct.pluck(:title)
  # end

  def self.title_of_products_in_atleast_one_line_item2
    where.associated(:line_items).distinct.pluck(:title)
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
    unless (MIN_DESCRIPTION_LENGTH..MAX_DESCRIPTION_LENGTH).include?(len)
      errors.add(:description, "description length should be < 5 and > 10")
    end
  end

  def discount_price_less_than_price
    if price.present? && discount_price.present? && price < discount_price
      errors.add(:base, "discount price cannot be more than price")
    end
  end

  private def set_default_title
    self.title ||= DEFAULT_NAME
  end

  private def set_discount_price
    self.discount_price ||= price
  end
end
