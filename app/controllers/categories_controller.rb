class CategoriesController < ApplicationController
  allow_unauthenticated_access

  def index
    @categories = Category.where(parent_id: nil).includes(:sub_categories)
  end
end
