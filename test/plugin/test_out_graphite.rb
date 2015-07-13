require 'helper'

class CarbonInputTest < Test::Unit::TestCase
  TCP_PORT = 2003
  CONFIG_NAME_KEY_PATTERN = %[
    port #{TCP_PORT}
    tag tcp.events
    format /^(?<key>\\S+)\\s+(?<val>\\S+)\\s+(?<time>\\S+)$/
    time_format %s
    bind 0.0.0.0
  ]

  def create_driver(conf = CONFIG_NAME_KEY_PATTERN, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::CarbonInput, tag).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal d.instance.port, TCP_PORT
    assert_equal d.instance.tag, 'tcp.events'
    assert_equal d.instance.format, '/^(?<key>\\S+)\\s+(?<val>\\S+)\\s+(?<time>\\S+)$/'
    assert_equal d.instance.bind, '0.0.0.0'

  end

end
