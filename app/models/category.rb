class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true, inverse_of: :sub_categories
  has_many :sub_categories, class_name: "Category", foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :all_sub_categories_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  validate :ensure_one_level_nesting_of_sub_categories
  validates :name, presence: true, uniqueness: { scope: :parent_id }

  def ensure_one_level_nesting_of_sub_categories
    return if parent_id.blank?
    return if parent.parent_id.blank?
    errors.add(:base, "Cannot be a sub-category of sub-category!!!")
  end

  def all_products_count
    count = products_count
    sub_categories.find_each do |sub_category|
      count += sub_category.products_count
    end
    count
  end
end
