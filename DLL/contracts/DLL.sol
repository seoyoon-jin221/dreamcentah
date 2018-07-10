pragma solidity ^0.4.24;


contract DLL
{
    struct node
    {
        string value;
    	string sorted_prev;
	    string sorted_next;
        string prev;
        string next;
        string key;
        int exists;
    }

    int public length = 0;
    string public sorted_head;
    string public sorted_tail;
    string public head;
    string public tail;

    mapping(string=>node) private objects;
    string constant public NULL = "";
    
    function compare(string _a, string _b) public pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }

    function insert(string key, string value, string targetkey) public returns (bool)
    {
        if(objects[key].exists == 1 || compare(key,"") == 0)
        {
            //if the key is already in use or empty key
            return false;
        }

        if(length == 0)
        {
            node memory object = node(value, NULL, NULL, NULL, NULL, key, 1);
            objects[key] = object;
            head = key;
            tail = key;
            sorted_head = key;
            sorted_tail = key;
            length++;
            return true;
        }
        
        if(compare(key,sorted_head) < 0) //if it is smallest string at head
        {
            node memory object1 = node(value, NULL, sorted_head, tail, NULL, key, 1);
            objects[key] = object1;
            objects[sorted_head].sorted_prev = key;
            sorted_head = key;
        }
        
        else if(compare(key,sorted_tail) > 0) //if it is largest string at tail
        {
            node memory object2 = node(value, sorted_tail, NULL, tail, NULL, key, 1);
            objects[key] = object2;
            objects[sorted_tail].sorted_next = key;
            sorted_tail = key;
        }

        else
        {
            string memory previndex = objects[targetkey].sorted_prev;
            string memory nextindex = targetkey;
            
            node memory object3 = node(value, previndex, nextindex, tail, NULL, key, 1);
            objects[key] = object3;
            
            objects[previndex].sorted_next = key;
            objects[nextindex].sorted_prev = key;

        }
        
        //by default push_back to end of unsorted list
        objects[tail].next = key;
        tail = key;

        length++;
        return true;
    }

    function pop_front() public returns (bool)
    {
        if(length == 0)
        {
            return false;
        }

        if(length == 1)
        {
            delete objects[head];
            head = NULL;
            tail = NULL;
            sorted_head = NULL;
            sorted_tail = NULL;
            length--;
            return true;
        }

        else
        {
            if(compare(head,sorted_head) == 0)
            {
                sorted_head = objects[sorted_head].sorted_next;
                objects[sorted_head].sorted_prev = NULL;
            }
            
            else if(compare(head,sorted_tail) == 0)
            {
                sorted_tail = objects[sorted_tail].sorted_prev;
                objects[sorted_tail].sorted_next = NULL;
            }
            
            else
            {
                string storage sprevkey = objects[head].sorted_prev;
                string storage snextkey = objects[head].sorted_next;
                objects[sprevkey].sorted_next = snextkey;
                objects[snextkey].sorted_prev = sprevkey;
            }
        }

        string storage tmp = objects[head].next;
        head = tmp;
        delete objects[objects[tmp].prev];
        objects[head].prev = NULL;

        length--;
        return true;
    }
    
    function pop_back() public returns (bool)
    {
        if(length == 0)
        {
            return false;
        }

        if(length == 1)
        {
            delete objects[head];
            head = NULL;
            tail = NULL;
            sorted_head = NULL;
            sorted_tail = NULL;
            length--;
            return true;
        }

        else
        {
            if(compare(tail,sorted_head) == 0)
            {
                sorted_head = objects[sorted_head].sorted_next;
                objects[sorted_head].sorted_prev = NULL;
            }
            
            else if(compare(tail,sorted_tail) == 0)
            {
                sorted_tail = objects[sorted_tail].sorted_prev;
                objects[sorted_tail].sorted_next = NULL;
            }
            
            else
            {
                string storage sprevkey = objects[tail].sorted_prev;
                string storage snextkey = objects[tail].sorted_next;
                objects[sprevkey].sorted_next = snextkey;
                objects[snextkey].sorted_prev = sprevkey;
            }
        }
        
        string storage temp = objects[tail].prev;
        tail = temp;
        delete objects[objects[temp].next];
        objects[tail].next = NULL;
        
        length--;
        return true;
    }

    function remove(string targetkey) public returns (bool)
    {
        if(objects[targetkey].exists != 1 || length == 0)
        {
            //if the key value is nonexistent or if list is empty
            return false;
        }

        //sorted 
        if(length == 1)
        {
            delete objects[targetkey];
            length--;
            return true;
        }
        
        if(compare(targetkey,sorted_head) == 0)
        {
            sorted_head = objects[sorted_head].sorted_next;
            objects[sorted_head].sorted_prev = NULL;
        }
        
        else if(compare(targetkey,sorted_tail) == 0)
        {
            sorted_tail = objects[sorted_tail].sorted_prev;
            objects[sorted_tail].sorted_next = NULL;
        }
        
        else
        {
            string storage sprevkey = objects[targetkey].sorted_prev;
            string storage snextkey = objects[targetkey].sorted_next;
            objects[sprevkey].sorted_next = snextkey;
            objects[snextkey].sorted_prev = sprevkey;
        }

        //unsorted
        if(compare(objects[targetkey].key, head) == 0)
        {
            head = objects[targetkey].next;
            objects[head].prev = NULL;
        }

        else if(compare(objects[targetkey].key, tail) == 0)
        {
            tail = objects[targetkey].prev;
            objects[tail].next = NULL;
        }

        else //if the entry is at neither the head or the tail of the list, at least 3 entries
        {
            string storage prevkey = objects[targetkey].prev;
            string storage nextkey = objects[targetkey].next;
            objects[prevkey].next = nextkey;
            objects[nextkey].prev = prevkey;
        }

        delete objects[targetkey];
        length--;
    }
    
    function front() public view returns (string)
    {
        if(length > 0)
        {
            return objects[head].key;
        }
    }

    function back() public view returns (string)
    {
        if(length > 0)
        {
            return objects[tail].key;
        }
    }

    function size() public view returns (int)
    {
        return length;
    }

    function clear() public returns (bool)
    {
        while(length > 0)
        {
            pop_back();
        }
    }
    
    function update(string key, string uvalue) public returns (bool)
    {
        if(objects[key].exists == 1)
        {
            objects[key].value = uvalue;
            return true;
        }
        return false;
    }

    function getEntry(string key) public view returns (string, string, string, string, string, string)
    {
        if(objects[key].exists != 1)
        {
            return;    
        }
        
        return (objects[key].key, objects[key].value, objects[key].prev, objects[key].next, objects[key].sorted_prev, objects[key].sorted_next);
    }
    
    function getSortedHead() public view returns (string, string, string, string, string, string)
    {
        if(compare(sorted_head,NULL) == 0)
        {
            return;    
        }
        return (objects[sorted_head].key, objects[sorted_head].value, objects[sorted_head].prev, objects[sorted_head].next, objects[sorted_head].sorted_prev, objects[sorted_head].sorted_next);
    }
}
