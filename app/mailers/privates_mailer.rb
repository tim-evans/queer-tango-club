class PrivatesMailer < ActionMailer::Base
  def inquire(private_class, from, body)
    @private = private_class
    mail(to: @private.contact,
         from: from,
         subject: "[Private Lessons] #{@private.teacher.name}",
         body: body)
  end
end
