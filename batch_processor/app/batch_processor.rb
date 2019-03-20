# frozen_string_literal: true

require 'set'

# Generic batch processor
# Consumes a list of operations(type, entity)
# and passes them off to an API for processing
class BatchProcessor
  attr_reader :processed, :errors

  def initialize(api)
    @api = api
    reset
  end

  def process_batch(update_records, &block)
    update_records.each do |record|
      error = nil
      begin
        process(record)
      rescue StandardError => e
        error = e
        raise e
        @errors += 1
      ensure
        @processed += 1
      end

      yield(record, e) if block_given?
    end
  end

  def process(update_record)
    operation = update_record.fetch('operation').downcase
    entity = update_record.fetch('entity')

    raise(ArgumentError, "unknown operation #{operation}") unless api_operation?(operation)
    @api.public_send(operation, entity)
  end

  def reset
    @processed = 0
    @errors = 0
  end

  private

  def api_operation?(operation)
    api_operations.member?(operation.to_sym)
  end

  def api_operations
    @api_operations ||=
      Set.new(@api.public_methods - Object.methods)
  end
end
