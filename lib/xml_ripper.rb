require "xml_ripper/version"
require "rexml/document"

module XmlRipper

  class Rip
    def initialize(&block)
      @before_action = proc {}
      @path_action = {}
      @after_action = proc {}
      instance_eval(&block) if block
    end

    def on_path(path, &block)
      @path_action[path] = block
    end

    def before(&block)
      @before_action = block
    end

    def after(&block)
      @after_action = block
    end

    def run(xml_file_path)
      File.open(xml_file_path) do |f|
        document = REXML::Document.new(f)
        @before_action.call(document)
        run_path_action(document)
        @after_action.call(document)
      end
    end

    def run_path_action(document)
      @path_action.each do |path, block|
        REXML::XPath.each(document, path) do |element|
          block.call(element)
        end
      end
    end
  end

  class Rip
    def initialize_from_file(path)
      instance_eval( File.read(path))
    end
  end

end
