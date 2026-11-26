class Product < ApplicationRecord
  MAX_DESCRIPTION_LENGTH = 10
  MIN_DESCRIPTION_LENGTH = 5
  DEFAULT_NAME = "abc"

  has_many_attached :images
  has_rich_text :description
  has_many :line_items, dependent: :restrict_with_exception
  has_many :carts, through: :line_items
  belongs_to :category, counter_cache: true
  scope :enabled, -> { where(enabled: true) }

  validates :title, :description, :images, :category_id, presence: true
  validates :price, numericality: { greater_than: 0, if: -> { price.present? } }
  validates :title, uniqueness: true, length: { minimum: 10, message: "must be at least 10 characters long" }
  validate :acceptable_images
  validates :permalink, uniqueness: true, format: { with: /\A[A-Za-z0-9]+(?:-[A-Za-z0-9]+){2,}\z/ }, allow_nil: true
  validate :description_word_count
  validate :discount_price_less_than_price
  validate :ensure_maximum_3_images
  # price non-custom validator
  # validates :price, comparison: { greater_than: :discount_price, if: -> { price.present? && discount_price.present? } }

  after_initialize :set_default_title
  before_save :set_discount_price
  after_commit -> { broadcast_refresh_later_to "products" }
  after_create_commit :increment_parent_products_count_in_category
  after_destroy_commit :decrement_parent_products_count_in_category
  after_update_commit :update_parent_products_count_in_category, if: :saved_change_to_category_id?
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

  def acceptable_images
    return unless images.attached?

    acceptable_types = [ "image/jpeg", "image/png", "image/gif" ]
    images.each do |image|
      unless acceptable_types.include?(image.content_type)
        errors.add(:image, "must be a JPEG, PNG, or GIF")
        break
      end
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

  def ensure_maximum_3_images
    if images.length > 3
      errors.add(:images, "Cannot attach more than 3 images")
    end
  end

  private def set_default_title
    self.title ||= DEFAULT_NAME
  end

  private def set_discount_price
    self.discount_price ||= price
  end

  private def increment_parent_products_count_in_category
    category.adjust_parent_products_count(1)
  end

  private def decrement_parent_products_count_in_category
    category.adjust_parent_products_count(-1)
  end

  private def update_parent_products_count_in_category
    old_category_id, new_category_id = saved_change_to_category_id
    Category.find(old_category_id).adjust_parent_products_count(-1)
    Category.find(new_category_id).adjust_parent_products_count(1)
  end
end
