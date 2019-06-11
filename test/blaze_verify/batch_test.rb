### BATCH ENDPOINT DOES NOT SUPPORT TEST KEYS YET ###

# require 'test_helper'
#
# module BlazeVerfiy
#   class BatchTest < Minitest::Test
#
#     def setup
#       BlazeVerify.api_key = 'test_7aff7fc0142c65f86a00'
#       @emails = ['jarrett@blazeverify.com', 'support@blazeverify.com']
#       @batch = BlazeVerify::Batch.new(@emails)
#       @batch_id ||= @batch.verify
#     end
#
#     def test_start_batch
#       refute_nil @batch_id
#     end
#
#     def test_batch_status
#       status = @batch.status
#       refute_nil status.message
#     end
#
#     def test_batch_complete
#       complete = @batch.complete?
#       assert complete == true || complete == false
#     end
#
#   end
# end
