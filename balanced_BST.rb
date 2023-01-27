

class Node
    attr_accessor :nodeData, :leftNode, :rightNode
    def initialize(nodeData = 0, leftNode = nil, rightNode = nil)
        @nodeData = nodeData
        @leftNode = leftNode
        @rightNode = rightNode
    end
end

class Tree
    attr_accessor :root, :inp
    def initialize(inp)
        @inp = inp
        @root = self.build_tree(inp)
    end

    def build_tree(inputArray)
        arr = inputArray.uniq.sort
        mid =(arr.length()/2).floor
        rt = Node.new
        rt.nodeData = arr[mid]
        if (mid > 0)
            leftArr = arr[0..mid-1]
            rt.leftNode = self.build_tree(leftArr)
        end

        if (arr.length > mid+1) 
            rightArr = arr[mid+1..arr.length-1]
            rt.rightNode = self.build_tree(rightArr)
        end
        return rt
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.rightNode, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.rightNode
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.nodeData}"
        pretty_print(node.leftNode, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.leftNode
      end
end


#consoleTest
testTree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts testTree.pretty_print


