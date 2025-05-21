require 'active_model'
require 'emailable'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [
  Minitest::Reporters::ProgressReporter.new(color: true)
]
Minitest.load_plugins
Minitest::PrideIO.pride!
