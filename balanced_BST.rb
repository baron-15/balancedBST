

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
        if (arr.length() == 0)
            return nil
        end
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
    def pretty_print(node = self.root, prefix = '', is_left = true)
        pretty_print(node.rightNode, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.rightNode
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.nodeData}"
        pretty_print(node.leftNode, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.leftNode
    end

    def insert(val, rt = self.root)
        if (rt == nil)
            rt = Node.new
            rt.nodeData = val
        elsif (val < rt.nodeData)
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

    def find(val, rt = self.root, parent = nil, isLeft = true)
        if (rt == nil)
            return false, parent, isLeft
        elsif (val == rt.nodeData)
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


    def level_order(rt = self.root, level = 0, lvo = [])
        if (lvo == [])
            puts self.pretty_print
            puts "Let's print the level order of the tree above!"
            lvo = Array.new(self.height())
            for i in 0..lvo.length()-1 do
                lvo[i] = []
            end
        end
        if (rt == nil)
            return
        end
        level += 1
        lvo[level-1].push(rt.nodeData)
        if (rt.leftNode != nil || rt.rightNode != nil)
            if (rt.leftNode != nil)
                lvo = level_order(rt.leftNode, level, lvo)
            end
            if (rt.rightNode != nil)
                lvo = level_order(rt.rightNode, level, lvo)
            end           
        end
        return lvo
    end

    def flatten(rt = self.root,  flt = [])
        if (flt == [])
            puts self.pretty_print
        end
        if (rt == nil)
            return flt
        end
        flt.push(rt.nodeData)
        if (rt.leftNode != nil || rt.rightNode != nil)
            if (rt.leftNode != nil)
                flt = flatten(rt.leftNode, flt)
            end
            if (rt.rightNode != nil)
                flt = flatten(rt.rightNode, flt)
            end           
        end
        return flt
    end

    def rebalance()
        newArr = self.flatten()
        puts "Rebalancing... #{newArr.inspect}"
        newTree = Tree.new(newArr)
        self.root = newTree.root
    end


    def height(rt = self.root, level = 0)
        if (level == 0)
            puts "In height function."
        end
        if (rt != nil)
            level += 1
        end
        puts "We are in level #{level} of height. The value is #{rt.nodeData}."
        if (rt.leftNode != nil || rt.rightNode != nil)
            if (rt.leftNode != nil)
                levelL = height(rt.leftNode, level)
            end
            if (rt.rightNode != nil)
                levelR = height(rt.rightNode, level)
            end
            if (rt.leftNode != nil)
                if (levelL > level)
                    level = levelL
                end
            end
            if (rt.rightNode != nil)
                if (levelR > level)
                    level = levelR
                end
            end
            
        end
        return level
    end

    def balanced?(rt = self.root)
            puts self.pretty_print
            puts "Let's see if the tree above is balanced."
            if (rt == nil)
                puts "Empty tree."
                return true
            end
        puts "We are looking at subtrees from node #{rt.nodeData} for balanced?."
        if (rt.leftNode != nil || rt.rightNode != nil)
            if (rt.leftNode != nil)
                leftHeight = self.height(rt.leftNode)
            else leftHeight = 0
            end
            puts "Left side's height is #{leftHeight}."
            if (rt.rightNode != nil)
                rightHeight = self.height(rt.rightNode)
            else rightHeight = 0
            end
            puts "Right side's height is #{rightHeight}."

            if ((leftHeight - rightHeight).abs() > 1)
                return false
            end
            if (rt.leftNode != nil)
                balancedL = balanced?(rt.leftNode)
                if (balancedL == false)
                    return false 
                end
            end
            if (rt.rightNode != nil)
                balancedR = balanced?(rt.rightNode)
                if balancedR == false
                    return false 
                end
            end
        else
            puts "This is a terminal node."
        end
        return true
    end
    
end


#consoleTest
testTree = Tree.new([10, 40, 50, 100, 5, 25, 200, 500, 1000, 35, 115, 375, 225, 1250, 1300, 2000, 250, 550, 575, 750])
puts
puts "Main: NEW TEST SESSION!"
puts "Main: NEW TEST SESSION!"
puts "Main: NEW TEST SESSION!"
puts
puts "Main: FIRST TREE"
puts testTree.pretty_print
puts
testTree.insert(400)
testTree.delete(35)
testTree.delete(40)
testTree.delete(550)
puts
puts "Main: TREE AFTER INSERT AND DELETE"
puts testTree.pretty_print
puts
puts "Main: The height of this tree is #{testTree.height()}."
puts
puts "Main: The level order print out for this tree is #{testTree.level_order().inspect}."
puts 
puts "Main: Is tree balanced?"
puts "Main: Therefore, is tree balanced? #{testTree.balanced?}"
puts
puts "Main: Regardless of the result above. Let's rebalance it."
testTree.rebalance()
puts
puts "Main: REBALANCED TREE"
puts testTree.pretty_print
puts
puts "Main: Is this balanced tree balanced?"
puts "Main: Therefore, is the balanced tree balanced? #{testTree.balanced?}"
puts