module BlazeVerify
  class BatchStatus < APIResource
    attr_accessor :emails, :id, :message, :reason_counts, :total_counts
  end
end
