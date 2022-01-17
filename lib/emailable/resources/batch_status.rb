module Emailable
  class BatchStatus < APIResource
    attr_accessor :emails, :id, :message, :reason_counts, :total_counts,
      :processed, :total

    def complete?
      message.include?('completed')
    end
  end
end
