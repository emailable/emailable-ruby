module Emailable
  class BatchStatus < APIResource
    attr_accessor :emails, :id, :message, :reason_counts, :total_counts,
      :processed, :total, :download_file

    def complete?
      message.include?('completed')
    end
  end
end
