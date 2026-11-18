class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, email: true
  has_secure_password
  before_destroy :before_destroy_prepend_log
  has_many :sessions, dependent: :destroy
  before_destroy :ensure_not_an_admin
  before_update :ensure_not_an_admin, :ensure_cannot_be_admin
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_validation :before_val_log
  after_validation :after_val_log

  before_save :before_save_log
  around_save :around_save_log
  after_save :after_save_log

  before_create :before_create_log
  around_create :around_create_log
  after_create :after_create_log

  after_commit :after_commit_log
  before_update :before_update_log
  around_update :around_update_log
  after_update :after_update_log
  before_destroy :before_destroy_log
  around_destroy :around_destroy_log
  after_destroy :after_destroy_log
  after_initialize :after_initialize_log
  after_find :after_find_log

  after_destroy :ensure_an_admin_remains
  after_create_commit :send_welcome_notif
  has_many :orders, dependent: :nullify
  has_many :line_items, through: :orders

  class Error < StandardError
  end

  private def ensure_an_admin_remains
    if User.count.zero?
      raise Error, "Can't delete last user"
    end
  end

  private def ensure_not_an_admin
    if email_address_in_database == "admin@depot.com"
      errors.add(:email, "Cannot change email of admin")
      throw :abort
    end
  end

  private def ensure_cannot_be_admin
    if email_address == "admin@depot.com"
      errors.add(:email, "cannot update email to this")
      throw :abort
    end
  end

  private def send_welcome_notif
    UserMailer.welcome_email(self).deliver_later
  end

  private def before_val_log
    puts "before_validation ran"
  end

  private def after_val_log
    puts "after_validation ran"
  end

  private def before_save_log
    puts "before_save ran"
  end

  private def around_save_log
    puts "around_save started"
    yield
    puts "around_save completed"
  end

  private def after_save_log
    puts "after_save ran"
  end

  private def before_create_log
    puts "before_create ran"
  end

  private def around_create_log
    puts "around_create started"
    yield
    puts "around_create completed"
  end

  private def after_create_log
    puts "after_create ran"
  end

  private def after_commit_log
    puts "after_commit ran"
  end

  private def before_update_log
    puts "before_update ran"
  end

  private def around_update_log
    puts "around_update started"
    yield
    puts "around_update completed"
  end

  private def after_update_log
    puts "after_update ran"
  end

  private def before_destroy_log
    puts "before_destroy ran"
  end

  private def around_destroy_log
    puts "around_destroy started"
    yield
    puts "around_destroy completed"
  end

  private def after_destroy_log
    puts "after_destroy ran"
  end

  private def after_initialize_log
    puts "after_initialize ran"
  end

  private def after_find_log
    puts "after_find ran"
  end

  private def before_destroy_prepend_log
    puts "before destroy prepend log"
  end
end
