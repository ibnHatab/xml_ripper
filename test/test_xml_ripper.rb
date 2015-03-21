require 'minitest/autorun'

require 'xml_ripper'

class TestXmlRipper < MiniTest::Unit::TestCase
  def setup
    @file = 'test/fellowship.xml'

  end

  def test_on_path
    t = self                    # shadowing self in instance_eval
    ripper = XmlRipper::Rip.new do
      on_path('document/author') do |author|
        author.text = 'JRRT'
      end
      on_path('document/chapter/title') do |title|
        puts '>> ' + title.text
      end
      after do |doc|
        t.assert_equal 'JRRT', REXML::XPath.first(doc, '/document/author').text
      end
    end

    ripper.run(@file)
  end

  def test_from_file
    ripper = XmlRipper::Rip.new
    ripper.initialize_from_file('test/fix_author.ripper')
    ripper.run(@file)
  end
end
