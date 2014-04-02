module Threequel
  class Script
    attr_accessor :code
    attr_accessor :path
    attr_accessor :file_name

    def initialize(path)
      @path = path
    end

    def file_name
      @file_name ||= "#{File.join(Rails.root, 'db', 'sql', @path)}.sql"
    end

    def code
      @code ||= IO.read(file_name).gsub(/\r\n?/, "\n")
    end

    def statements
      code.split("GO\n").compact
    end

    def sql
      statements.join("\n")
    end
  end
end
