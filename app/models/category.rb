class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true, inverse_of: :sub_categories
  has_many :sub_categories, class_name: "Category", foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :all_sub_categories_products, through: :sub_categories, source: :products, dependent: :restrict_with_error

  validate :ensure_one_level_nesting_of_sub_categories
  validates :name, presence: true, uniqueness: { scope: :parent_id }

  after_update_commit :update_parent_products_count, if: :saved_change_to_parent_id?

  def ensure_one_level_nesting_of_sub_categories
    return if parent_id.blank?
    return if parent.parent_id.blank?
    errors.add(:base, "Cannot be a sub-category of sub-category!!!")
  end

  private def update_parent_products_count
    old_parent_id, new_parent_id = saved_change_to_parent_id
    old_parent = Category.find(old_parent_id)
    new_parent = Category.find(new_parent_id)
    Category.update_counters(old_parent.id, products_count: -products_count)
    Category.update_counters(new_parent.id, products_count: products_count)
  end

  def adjust_parent_products_count(amount)
    if parent
      Category.update_counters(self.parent.id, products_count: amount)
    end
  end
end
