namespace :transactions do
  desc "Migrate expenses and attendees to transactions"
  task :migrate => :environment do
    Expense.transaction do
      group = Group.first
      Expense.all.each do |expense|
        transaction = Transaction.create!({
          description: expense.name,
          notes: expense.description,
          paid_by: expense.expensed_by || 'Anonymous',
          paid_at: expense.expensed_at,
          amount: expense.amount * -1,
          currency: expense.currency || 'USD',
          receipt_id: expense.receipt_id,
          group: group
        })

        if expense.event
          expense.payment = transaction
          expense.save!
        else
          expense.destroy!
        end
      end

      Attendee.all.each do |attendee|
        transaction = Transaction.create!({
          description: attendee.session.title,
          paid_by: attendee.member.name || 'Anonymous',
          paid_at: attendee.paid_at,
          amount: attendee.payment_amount,
          currency: attendee.payment_currency || 'USD',
          url: attendee.payment_url,
          method: attendee.payment_method,
          group: group
        })

        attendee.payment = transaction
        attendee.save!
      end
    end
  end
end
