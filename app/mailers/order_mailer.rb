# coding: utf-8
class OrderMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def confirmation_email(member, order)
    @member = member
    @order = order

    attachments['event.ics'] = {
      mime_type: 'application/ics',
      content: ItineraryService.new(order.sessions).itinerary
    }

    mail(to: member.formatted_email,
         subject: "Your #{order.event.title} Order / Queer Tango Club")
  end
end
