require 'fluent/test'
require 'fluent/plugin/in_tail_path'

class TailPathInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    FileUtils.rm_rf(TMP_DIR)
    FileUtils.mkdir_p(TMP_DIR)
  end

  TMP_DIR = File.dirname(__FILE__) + "/../tmp/tail#{ENV['TEST_ENV_NUMBER']}"

  COMMON_CONFIG = %[
    path #{TMP_DIR}/tail.txt
    tag t1
    rotate_wait 2s
    pos_file #{TMP_DIR}/tail.pos
  ]
  SINGLE_LINE_CONFIG = %[
    format /(?<message>.*)/
  ]

  def create_driver(conf = SINGLE_LINE_CONFIG, use_common_conf = true)
    config = use_common_conf ? COMMON_CONFIG + conf : conf
    Fluent::Test::InputTestDriver.new(Fluent::NewTailPathInput).configure(config)
  end

  def test_path_key
    File.open("#{TMP_DIR}/tail.txt", "w") { |f| }

    d = create_driver(%[
       path #{TMP_DIR}/tail.txt
       tag t1
       format /(?<message>.*)/
       path_key foobar
    ], false)

    d.run do
      sleep 1

      File.open("#{TMP_DIR}/tail.txt", "a") {|f|
        f.puts "test1"
        f.puts "test2"
      }
      sleep 1
    end

    emits = d.emits
    assert_equal(true, emits.length > 0)
    assert_equal({"message"=>"test1", "foobar"=>"#{TMP_DIR}/tail.txt"}, emits[0][2])
    assert_equal({"message"=>"test2", "foobar"=>"#{TMP_DIR}/tail.txt"}, emits[1][2])
  end
end
