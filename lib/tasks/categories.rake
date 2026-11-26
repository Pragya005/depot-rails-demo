namespace :categories do
  desc "Recalculate products_count for parent categories"

  task parent_products_count_recalculate: :environment do
    Category.where(parent_id: nil).find_each do |category|
      total_count = category.products.count + category.sub_categories.sum(:products_count)
      category.update_column(:products_count, total_count)
    end
    puts "Parent category counts recalculated!!"
  end
end
