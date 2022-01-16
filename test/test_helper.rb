require 'emailable'

require 'pry'
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [
  Minitest::Reporters::ProgressReporter.new(color: true)
]
Minitest.load_plugins
Minitest::PrideIO.pride!
