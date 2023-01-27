class Directory
    attr_accessor :parent, :name, :size, :children
    def initialize(parent = nil, name = '', size = 0, children = [])
        @parent = parent
        @name = name
        @size = size
        @children = children
    end
end

part1 = File.open("input.txt", "r")

number = 0
prt = nil
line = part1.readline
puts line.to_s
folder = Hash.new
allFolders = Array.new
allFiles = Array.new
d = Directory.new(nil, "/", 0,)
allFolders.push(d)
prt = d
lsbrk = 0

while !part1.eof?
    if lsbrk == 0
        line = part1.readline.split(/ /, 3)
        line[-1].strip!
        puts line.to_s
    else
        lsbrk = 0
    end

    if line[0] == "$"
        if line[1] == "cd"
            if line[2] != ".."
                puts "How should I handle d.children?"
                puts prt.children
                prt.children.each do |child|
                    if child.name == line[2]
                        prt = child
                        puts "Entering the folder #{prt}."
                        break
                    end
                end
            else
                puts "Exiting the folder #{prt}"
                prt = prt.parent
            end
            puts "prt updated to #{prt}"
        else #ls
            line = part1.readline.split(/ /, 2)
            line[-1].strip!
            puts line.to_s
            while line[0] != "$"
                if line[0] == "dir"
                    puts "we are in dir of #{line[1]}"
                    d = Directory.new(prt, line[1],0,)
                    prt.children.push(d)
                    allFolders.push(d)
                else #not dir, which means filesize first
                    puts "we have a file, parent is #{prt}"
                    d = Directory.new(prt, line[1], line[0].to_i,)
                    prt.children.push(d)
                    allFiles.push(d)
                end
                if !part1.eof?
                    line = part1.readline.split(/ /, 3)
                    line[-1].strip!
                end
                break if part1.eof?
            end
            lsbrk = 1
        end
    end
end


allFiles.each do |item|
    puts "Let's look at file #{item.name}, size #{item.size}."
    itemSize = item.size
    while (item.parent != nil)
        puts "Its parent is #{item.parent.name}"
        puts "Current size is #{item.parent.size}"
        item.parent.size += itemSize
        puts "Updated size is #{item.parent.size}"
        item = item.parent
    end
end

filtersum = 0
allFolders.each do |folder|
    if (folder.size <= 100000)
        filtersum += folder.size 
    end
end

puts "Sum under 100,000 is #{filtersum}."

rootSize = 0
allFolders.each do |folder|
    if folder.parent == nil
        rootSize = folder.size
        puts "The root folder size is #{folder.size}."
    break
    end
end

needToDelete = rootSize - (70000000 - 30000000)

minimum = 0

allFolders.each do |folder|
    if folder.size >= needToDelete
        if minimum == 0
            minimum = folder.size
        else
            if folder.size < minimum
                minimum = folder.size
            end
        end
    end
end

puts "Minimum size to delete is #{minimum}."