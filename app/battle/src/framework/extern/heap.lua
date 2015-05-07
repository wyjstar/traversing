--[[
	Heap()  -- create a heap object

	Heap:insert(key, item) -- inserts an item of any type into the heap.
									Keys work best as integers.
	Heap:get_min() -- find the minimum item in the heap and return it

	Heap:delete_min() -- remove the minimum item

	Heap:clear_heap() -- clear the heap

	Heap:print_heap() -- prints the heap keys in level order notation
]]


--[[
test_heap = Heap()

test_heap:insert( 84, "blah")
test_heap:insert( 32, "hddfhh")
test_heap:insert( 66, "hfhhfd")
test_heap:insert( 77, "fjjjf")
test_heap:insert( 2, "min")
test_heap:insert( 3, "new min")
test_heap:insert( 4, "fggjjg")

test_heap:print_heap()
print(test_heap:get_min())

test_heap:delete_min()

test_heap:print_heap()
print(test_heap:get_min())]]

Heap = {}
Heap_mt = { __index = Heap}

function Heap:make_heap()
   return setmetatable({heap={}, size=0}, Heap_mt)
 end

setmetatable(Heap, {__call = Heap.make_heap})

function Heap:heapify_node(index)
    lchild = self:l_child(index);
    rchild = self:r_child(index);

    if (0 <= lchild and lchild <= self.size + 1 and self.heap[lchild].key < self.heap[index].key) then
        temp = self.heap[lchild];
        self.heap[lchild] = self.heap[index];
        self.heap[lchild].position = lchild;
        self.heap[index] = temp;
        self.heap[index].position = index;
    end

    if (0 <= rchild and rchild <= self.size + 1 and self.heap[rchild].key < self.heap[index].key) then
        temp = self.heap[rchild];
        self.heap[rchild] = self.heap[index];
        self.heap[rchild].position = rchild;
        self.heap[index] = temp;
        self.heap[index].position = index;
    end
end

function Heap:insert(key, item)
    return_spot = 0;
    new_node = {};
    new_node.key = key;
    new_node.item = item;
    self.heap[self.size] = new_node;
    return_spot = self:heapify_up(self.size);
    new_node.position = return_spot;
    self.size = self.size + 1;
    return return_spot;
end

function Heap:get_len()
    return self.size
end

function Heap:get_min()
    if (self.size > 0) then
        return self.heap[0].item;
    else
        return nil;
    end
end

function Heap:delete_min()
    return self:delete_node(0);
end

function Heap:delete_node(position)
    if (self.size > 0) then
        self.heap[position] = self.heap[self.size - 1];
        self.size = self.size - 1;
        return self:heapify_down( position, self.heap[position]);
    else
        return -1;
    end
end

function Heap:heapify_down( cur_index, move_content)
    l_child_index = self:l_child(cur_index);
    r_child_index = self:r_child(cur_index);
    min_index = 0;

    --if the node has leaves, find the index of the minimum element, else min_index =  -1
    indexes = {};
    array_size = 0;
    if (l_child_index ~= -1 and self.heap[l_child_index].key < move_content.key) then
        indexes[array_size] = l_child_index;
        array_size = array_size + 1;
    end

    if (r_child_index ~= -1 and self.heap[r_child_index].key < move_content.key) then
        indexes[array_size] = r_child_index;
        array_size = array_size + 1;
    end
		
    if (array_size == 2) then
        if(self.heap[indexes[1] ].key < self.heap[indexes[0] ].key) then
            temp = indexes[1];
	indexes[1] = indexes[0];
	indexes[0] = temp;
        end
    end

    if (array_size == 0) then
        min_index = -1;
    else  
        min_index = indexes[0];
    end


    if (min_index ~= -1) then
        self.heap[cur_index] = self.heap[min_index];
        self.heap[cur_index].position = cur_index;
        return self:heapify_down(min_index, move_content);
    else
        self.heap[cur_index] = move_content;
        self.heap[cur_index].position = cur_index;
        return cur_index;
    end
end

function Heap:heapify_up(starting_spot)
    move_index = starting_spot;
    move_content = self.heap[move_index];
    cur_index = move_index;
    parent_index = self:parent(cur_index);
    while (parent_index > -1 and self.heap[parent_index].key > move_content.key ) do
        self.heap[cur_index] = self.heap[parent_index];
        self.heap[cur_index].position = cur_index;
        cur_index = parent_index;
        parent_index = self:parent(cur_index);
    end

    self.heap[cur_index] = move_content;
    self.heap[cur_index].position = cur_index;
    return cur_index;
end

function Heap:clear_heap( )
    self.heap = {};
    self.size = 0;
end

function Heap:parent(position)
    return math.floor(  (position - 1.0) / 2.0)  ;
end

function Heap:r_child(position)
    return_position = 2*position + 2;
    if (return_position > self.size - 1) then
        return -1;
    else
        return return_position;
    end
end

function Heap:l_child(position)
    return_position = 2*position + 1;
    if (return_position > self.size - 1)  then
        return -1;
    else
        return return_position;
    end
end

function Heap:print_heap()
    return_string = "";
    carriage_return = 2;
    for i = 0, self.size - 1 do
        return_string = return_string .. self.heap[i].key .. " " ;
        if (i == ( carriage_return - 2 )) then
            carriage_return = carriage_return * 2;
            return_string = return_string .. "\n";
        end
    end

    return_string = return_string .. "\n";
    print(return_string);
end

--[[
test_heap = Heap()

test_heap:insert( 84, "blah")
test_heap:insert( 32, "hddfhh")
test_heap:insert( 66, "hfhhfd")
test_heap:insert( 77, "fjjjf")
test_heap:insert( 2, "min")
test_heap:insert( 3, "new min")
test_heap:insert( 4, "fggjjg")

test_heap:print_heap()
print(test_heap:get_min())

test_heap:delete_min()

test_heap:print_heap()
print(test_heap:get_min())]]


--]]



