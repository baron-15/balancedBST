

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

    # def pretty_print created by TOP, not me
    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.rightNode, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.rightNode
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.nodeData}"
        pretty_print(node.leftNode, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.leftNode
    end

    def insert(val, rt = root)
        if (val < rt.nodeData)
            if (rt.leftNode != nil)
                rt = rt.leftNode
                insert(val, rt)
            else
                newNode = Node.new(val)
                rt.leftNode = newNode
                puts "Inserted #{val}, a left node."
                return
            end
        elsif (val > rt.nodeData)
            if (rt.rightNode != nil)
                rt = rt.rightNode
                insert(val, rt)
            else
                newNode = Node.new(val)
                rt.rightNode = newNode
                puts "Inserted #{val}, a right node"
                return
            end
        else
            puts "Found a duplicate. Invalid insert."
        end
    end

    def find(val, rt = root, parent = nil, isLeft = true)
        if (val == rt.nodeData)
            puts "Found #{val}."
            return rt, parent, isLeft
        elsif (val < rt.nodeData)
            if (rt.leftNode != nil)
                parent = rt
                rt = rt.leftNode
                isLeft = true
                find(val, rt, parent, isLeft)
            else
                puts "Not found."
                return false, parent, isLeft
            end
        else
            if (rt.rightNode != nil)
                parent = rt
                rt = rt.rightNode
                isLeft = false
                find(val, rt, parent, isLeft)
            else
                puts "Not found."
                return false, parent, isLeft
            end
        end
    end

    def delete(val)
        puts "Deleting #{val}."
        found = self.find(val)
        rt = found[0]
        if (rt == false)
            puts "Cannot delete."
            return false
        else
            parent = found[1]
            isLeft = found[2]
            puts "Its parent is #{parent.nodeData}."
            if (rt.leftNode == nil && rt.rightNode == nil)
                puts "#{val} a terminal node."
                if (isLeft)
                    parent.leftNode = nil
                else
                    parent.rightNode = nil
                end
            elsif (rt.leftNode == nil)
                puts "#{val} is a node with only right children, #{rt.rightNode.nodeData}."
                puts "Connecting #{parent.nodeData} with #{rt.rightNode.nodeData}."
                if (isLeft)
                    parent.leftNode = rt.rightNode
                else
                    parent.rightNode = rt.rightNode
                end
            elsif (rt.rightNode == nil)
                puts "#{val} is a node with only left children, #{rt.leftNode.nodeData}."
                puts "Connecting #{parent.nodeData} with #{rt.leftNode.nodeData}."
                if (isLeft)
                    parent.leftNode = rt.leftNode
                else
                    parent.rightNode = rt.leftNode
                end
            # Now the fun one: Delete a node with children on both sides.
            # Big idea: find the largest value in left node to replace it. Then delete that node.
            # "That node" should fit in one of three cases above.
            else
                puts "#{val} is a node with two children, #{rt.leftNode.nodeData} and  #{rt.rightNode.nodeData}."
                replacement = rt.leftNode
                while (replacement.rightNode != nil)
                    replacement = replacement.rightNode
                end
                replacementData = replacement.nodeData
                puts "The value to replace that node is #{replacementData}. Saved."
                self.delete(replacementData)
                puts "Final step: replacing #{val} with #{replacementData}."
                rt.nodeData = replacementData
            end
        end
    end
end


#consoleTest
testTree = Tree.new([10, 40, 50, 100, 5, 25, 200, 500, 1000, 35, 115, 375, 225, 1250, 1300, 2000, 250, 550, 575, 750])
puts testTree.pretty_print
testTree.insert(400)
puts testTree.pretty_print
testTree.delete(115)
puts testTree.pretty_print
testTree.delete(550)
puts testTree.pretty_print