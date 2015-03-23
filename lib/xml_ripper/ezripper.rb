require 'xml_ripper/ripper'

module XmlRipper

  class EzRipper
    def initialize(script_path)
      @ripper = Ripper.new
      parse(script_path)
    end

    def parse(script_path)
      File.open(script_path) do |f|
        until f.eof?
          parse_statement(f.readline)
        end
      end
    end

    def parse_statement(statement)
      statement = statement.sub(/#.*/, '')
      tokens = statement.strip.split
      return if tokens.empty?

      case tokens.first
      when 'print'
        raise "Expected print <xpath>" unless tokens.size == 2
        @ripper.on_path(tokens[1]) do |e|
          puts e.text
        end
      when 'delete'
        @ripper.on_path(tokens[1]) { |e| e.remove }
      when 'replace'
        @ripper.on_path(tokens[1]) { |e| e.text = tokens[2] }
      when 'dump'
        @ripper.after do |doc|
          puts doc
        end
      end
    end

    def run(xml_file)
      @ripper.run(xml_file)
    end
  end
end
