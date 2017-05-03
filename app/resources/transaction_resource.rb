class TransactionResource < BaseResource
  attributes :description, :amount, :currency, :paid_at, :paid_by, :iou, :url, :notes, :method

  def method
    @model.attributes['method']
  end

  def method=(value)
    @model.attributes['method'] = value
  end

  has_one :event
  has_one :receipt, class_name: 'Photo'

  before_create do
    @model.group = context[:group]
  end

  filter :event, apply: ->(records, value, _options) {
    name = value[0]
    if name.blank?
      records
    else
      records.where(event_id: value[0])
    end
  }

  def self.records(options={})
    if options[:context][:current_user]
      options[:context][:group].transactions
    end
  end
end
