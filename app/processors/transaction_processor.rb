class TransactionProcessor < BaseProcessor
  after_find do
    unless @result.is_a?(JSONAPI::ErrorsOperationResult)
      @result.meta[:balance] = {
        amount: @result.resources.map(&:amount).reduce(&:+) || 0,
        currency: @result.resources.first.try(:currency) || 'USD'
      }
    end
  end
end
