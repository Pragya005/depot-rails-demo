class StoreController < ApplicationController
  allow_unauthenticated_access
  include CurrentCart
  include StoreIndexCounter
  before_action :set_cart

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      increment_page_view_counter
      @products = Product.order(:title)
    end
  end
end
