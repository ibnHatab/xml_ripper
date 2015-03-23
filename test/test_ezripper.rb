require 'minitest/autorun'

require 'xml_ripper/ezripper'

class TestEzRipper < MiniTest::Unit::TestCase
  def setup
    @file = 'test/fellowship.xml'
  end

  def test_from_script
    ezripper = XmlRipper::EzRipper.new('test/edit.ezr')
    ezripper.run(@file)
  end
end
