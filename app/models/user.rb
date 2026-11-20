ADMIN_EMAIL = "admin@depot.com"
class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, email: true
  has_secure_password
  has_many :sessions, dependent: :destroy
  before_destroy :ensure_not_an_admin
  before_update :ensure_not_an_admin, :ensure_cannot_be_admin
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_notification_to_user_mail

  class Error < StandardError
  end

  private def ensure_an_admin_remains
    if User.count.zero?
      raise Error, "Can't delete last user"
    end
  end

  private def ensure_not_an_admin
    if email_address_in_database == ADMIN_EMAIL
      errors.add(:email, "Cannot change email of admin")
      throw :abort
    end
  end

  private def ensure_cannot_be_admin
    if email_address == ADMIN_EMAIL
      errors.add(:email, "cannot update email to this")
      throw :abort
    end
  end

  private def send_welcome_notification_to_user_mail
    UserMailer.welcome_email(self).deliver_later
  end
end
