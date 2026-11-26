namespace :products do
  desc "Update products with nil category_id"

  task port_legacy_products: :environment do
    first_category = Category.first
    if first_category.nil?
      puts "No category found!! Task aborted"
      next
    end

    Product.find_each do |product|
      if product.category_id.nil?
        product.update!(category: first_category)
      end
    end
  end
end
