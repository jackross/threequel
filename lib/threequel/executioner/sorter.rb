module Threequel
  class Sorter
    attr_reader :tsorted

    class TSortableHash < Hash
      include TSort
      alias tsort_each_node each_key
      def tsort_each_child(node, &block)
        fetch(node).each(&block)
      end
    end

    def initialize(tree)
      @tree = TSortableHash.new.merge! tree
      @tsorted = @tree.tsort
    end

    def dependencies(node)
      @tree[node]
    end

    def dependents(node)
      r = []
      @tree.each do |k, v|
        r << k if v.include?(node)
      end
      r.uniq
    end

    def roots
      @roots ||= tsorted.select{|m| dependencies(m) == []}
    end

    def leaves
      @leaves ||= tsorted.select{|m| dependents(m) == []}
    end

    def standalone
      @standalone ||= tsorted.select{|m| dependencies(m) == [] && dependents(m) == []}
    end

    def chainable
      @chainable ||= tsorted - standalone
    end

    def chains
      nodes = chainable.dup
      result = chain_for(nodes)
      standalone.reverse.each{|node| result.unshift [node]}
      result
    end

    def full_dependencies(node, accumulator = [])
      dependencies(node).each do |node|
        full_dependencies(node, accumulator)
      end
      accumulator << node
    end

    private
    def chain_for(nodes, accumulator = [])
      unless nodes == []
        node = nodes.pop
        d = full_dependencies(node)
        accumulator << d
        chain_for(nodes - d, accumulator)
      else
        accumulator
      end
    end
  end
end
