$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'blaze_verify'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [
  Minitest::Reporters::ProgressReporter.new(color: true)
]
Minitest.load_plugins
Minitest::PrideIO.pride!
