require 'test_helper'

module Emailable
  class BatchTest < Minitest::Test

    def setup
      sleep(1)
      Emailable.api_key = 'test_7aff7fc0142c65f86a00'
      @emails = ['jarrett@emailable.com', 'support@emailable.com']
      @batch = Emailable::Batch.new(@emails)
      @batch_id ||= @batch.verify
      sleep(1)
    end

    def test_start_batch
      refute_nil @batch_id
    end

    def test_batch_status
      status = @batch.status
      refute_nil status.message
    end

    def test_batch_complete
      complete = @batch.complete?
      assert complete == true || complete == false
    end

  end
end
