module Emailable
  class BatchStatus < APIResource
    attr_accessor :emails, :id, :message, :reason_counts, :total_counts,
      :processed, :total

    def complete?
      !emails.nil?
    end
  end
end
