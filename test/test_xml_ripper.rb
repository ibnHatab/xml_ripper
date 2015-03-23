require 'minitest/autorun'

require 'xml_ripper/ripper'

class TestXmlRipper < MiniTest::Unit::TestCase
  def setup
    @file = 'test/fellowship.xml'

  end

  def test_dummy
    skip('Some were in the another galaxy')
    assert_equal true, false
  end

  def test_on_path
    t = self                    # shadowing self in instance_eval
    ripper = XmlRipper::Ripper.new do
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
    ripper = XmlRipper::Ripper.new
    ripper.initialize_from_file('test/fix_author.ripper')
    ripper.run(@file)
  end

  def test_method_missing
    t = self                    # shadowing self in instance_eval
    ripper = XmlRipper::Ripper.new do
      on_document_author { |author| author.text = 'JRRT' }
      after do |doc|
        t.assert_equal 'JRRT', REXML::XPath.first(doc, '/document/author').text
      end
    end
    ripper.run(@file)
  end

end
