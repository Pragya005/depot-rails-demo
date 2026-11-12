# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/received
  def received
    OrderMailer.received
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/shipped
  def shipped
    OrderMailer.shipped
  end

  def ship_date_updated
    OrderMailer.ship_date_updated
  end
end
