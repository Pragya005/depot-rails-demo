require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def new_product(filename, content_type)
    Product.new(title: "My Book Title",
                description: "yyy",
                price: 1).tap do |product|
      product.image.attach(io: File.open("db/images/#{filename}"), filename: filename, content_type: content_type)
    end
  end
  
  test 'image url' do
    product = new_product("img.png", "image/png")
    assert product.valid?, "image/jpeg must be valid"

    product = new_product("alien.svg", "image/svg+xml")
    assert product.invalid?, "image/svg+xml should be invalid"
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title", description: "yyy")
    product.image.attach(io: File.open("db/images/img.png"), filename: "img.png", content_type: "image/png")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than 0"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than 0"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end
end
