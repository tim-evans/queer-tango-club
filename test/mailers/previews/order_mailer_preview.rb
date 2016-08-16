# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  include Roadie::Rails::Mailer

  def confimation_email
    @order = OrderService.new(Workshop.last.sessions)
    OrderMailer.confirmation_email(Member.first, @order)
  end
end
