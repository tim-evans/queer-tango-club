class TransactionResource < BaseResource
  attributes :description, :amount, :currency, :paid_at, :paid_by, :iou, :url, :notes, :method

  def method
    @model.attributes['method']
  end

  def method=(value)
    @model.attributes['method'] = value
  end

  has_one :receipt, class_name: 'Photo'

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    if options[:context][:current_user]
      options[:context][:group].transactions
    end
  end
end
