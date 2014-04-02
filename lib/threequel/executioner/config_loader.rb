module Threequel
  module Executioner
    class ConfigLoader
      def initialize(folder_path)
        @folder_path = folder_path
      end

      def dependency_tree
        @dependency_tree ||= {}.tap{|h| scripts.each{|k, v| h[k] = v[:dependencies]}}
      end

      def sorter
        @sorter ||= Sorter.new(dependency_tree)
      end

      def scripts
        config[:scripts]
      end

      def script_chains
        @script_chains ||= sorter.chains
      end

      def tsorted_scripts
        @tsorted_scripts ||= sorter.tsorted
      end

      def config
        @config ||= YAML.load_file(File.join(Rails.root, "db", "sql", @folder_path, "config.yml")).with_indifferent_access
      end
    end
  end
end
