class Discount < ActiveRecord::Base
  monetize :fractional, as: :amount, with_model_currency: :currency

  belongs_to :event

  def expired?(at: DateTime.now)
    at > valid_until
  end

  def apply_to?(sessions, at: DateTime.now)
    return [] if expired?(at: at)

    sessions = sessions.where(id: active_when['ids']) if active_when.key?('ids')
    if active_when['count']
      if sessions.count == active_when['count']
        sessions
      else
        []
      end
    else
      sessions
    end
  end
end
