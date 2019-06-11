module BlazeVerify
  class BatchStatus < APIResource
    attr_accessor :emails, :id, :message, :reason_counts, :total_counts

    def complete?
      !emails.nil?
    end
  end
end
