class SaveTwilioInfoJob
    include Sidekiq::Job

    # Retry up to 3 times
    sidekiq_options retry: 3

    def perform(twilio_id, twilio_request_info)
        # extract the twilio_id
        # at this point call the 
        begin
            comm = TwilioCommunication.new(
                twilio_id: twilio_id, 
                details: twilio_request_info.to_h
            )
            comm.save
        rescue => e
        end
    end
end