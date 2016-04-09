require_relative 'helper'
require 'fluent/plugin/in_tail_path'

class TailPathInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end
end
