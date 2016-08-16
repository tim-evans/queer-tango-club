class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.email_address
  add_template_helper(ApplicationHelper)
  layout 'mailer'
end
