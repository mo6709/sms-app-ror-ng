class SmsMessageSerializer
  include JSONAPI::Serializer
  
  attributes :to_number, :message, :status, :created_at
  
  attribute :error_message, if: Proc.new { |record| record.status == 'failed' }
  attribute :external_id, if: Proc.new { |record| record.status == 'sent' }
end 