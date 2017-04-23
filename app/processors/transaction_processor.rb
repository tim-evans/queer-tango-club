class TransactionProcessor < JSONAPI::Processor
  after_find do
    unless @result.is_a?(JSONAPI::ErrorsOperationResult)
      @result.meta[:total] = @result.resources.map(&:amount).reduce(&:+)
      # @result.meta[:currency] = @context[:group].currency
    end
  end
end
