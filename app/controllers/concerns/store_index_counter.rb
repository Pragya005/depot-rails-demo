module StoreIndexCounter
  extend ActiveSupport::Concern

  private def increment_page_view_counter
    session[:counter] ||= 0
    session[:counter] += 1
  end

  private def reset_page_view_counter
    session[:counter] = 0
  end
end
