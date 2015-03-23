require "rexml/document"

module XmlRipper

  # The main Ripper driver
  class Ripper

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

  # Scripting capabilities
  class Ripper
    def initialize_from_file(path)
      instance_eval( File.read(path), path)
    end
  end

  # dynamic extensions
  class Ripper

    def method_missing(name, *args, &block)
      return super unless name.to_s =~ /on_.*/
      xpath = name.to_s.split('_').drop(1).join('/')
      on_path(xpath, &block)
    end

  end

end
