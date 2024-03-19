require 'test_helper'

module Emailable
  module Resources
    class APIResourceTest < Minitest::Test
      class Example < APIResource
        attr_accessor :foo, :bar, :baz
      end

      def setup
        @e = Example.new(foo: 'abc', bar: 123, baz: true)
      end

      def test_init
        assert_equal 'abc', @e.foo
        assert_equal 123,   @e.bar
        assert @e.baz
      end

      def test_to_h
        correct = {
          foo: 'abc',
          bar: 123,
          baz: true,
        }
        assert_equal correct, @e.to_h
        assert_equal correct, @e.to_hash
      end

      def test_to_json
        correct = %q|{"foo":"abc","bar":123,"baz":true}|
        assert_equal correct, @e.to_json
      end

      def test_inspect
        correct = <<~STR.chomp
          #<> JSON: {
            "foo": "abc",
            "bar": 123,
            "baz": true
          }
        STR
        output = @e.inspect.gsub(/<.*>/, '<>')
        assert_equal correct, output
      end
    end

  end
end
