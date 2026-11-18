class Session < ApplicationRecord
  belongs_to :user
  before_destroy :session_before_destroy_log

  private def session_before_destroy_log
    puts "session wala before destroy"
  end
end
