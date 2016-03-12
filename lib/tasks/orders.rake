namespace :orders do
  desc "Fix attribution for orders"
  task :fix_attribution => :environment do
    orders = {}
    Event.find_by_title("MarchFest").attendees.each do |attendee|
      member = attendee.member
      if orders[member].blank?
        orders[member] = []
      end
      orders[member] << attendee
    end

    orders.each do |member, attendees|
      payment_method = attendees.first.payment_method
      payment_amount = attendees.first.amount_paid
      paid_at = attendees.first.paid_at
      sessions = Session.where(id: attendees.map(&:session).map(&:id))

      case payment_method
      when 'cash'
        Timecop.freeze(paid_at)
        order = OrderService.new(sessions)
        if order.total != payment_amount
          title = "Adjusting #{member.name} (#{order.total.format} != #{payment_amount.format})"
          puts title
          puts '=' * title.size
          order.final_attribution(payment_amount).each do |session, attribution|
            puts "#{session.title}".ljust(50) + attribution.format
#            attendee = attendees.find { |a| a.session.id == session.id }
#            attendee.update_attributes({
#              payment_currency: attribution.currency.to_s,
#              payment_amount: attribution.fractional
#            })
          end
          puts (" " * 50) + payment_amount.format
        end
        puts ""
        Timecop.return
      when 'stripe'
        payment_url = attendees.first.payment_url
        order_id = payment_url.split("/").last
        order = Stripe::Order.retrieve(order_id)
        charge = Stripe::Charge.retrieve(order.charge)
        balance_transaction = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
        net_total = Money.new(balance_transaction.net, balance_transaction.currency)

        Timecop.freeze(paid_at)
        order = OrderService.new(sessions)
        title = "Adjusting #{member.name} (#{order.total.format} != #{payment_amount.format})"
        puts title
        puts '=' * title.size

        order.final_attribution(net_total).each do |session, attribution|
          puts "#{session.title}".ljust(50) + attribution.format
#          attendee = attendees.find { |a| a.session.id == session.id }
#          attendee.update_attributes({
#            payment_currency: attribution.currency.to_s,
#            payment_amount: attribution.fractional
#          })
        end
        puts (" " * 50) + net_total.format
        puts ""
        Timecop.return
      end
    end
  end
end
