contract c {
    uint[] data;
    function enlarge(uint amount) public returns (uint) { return data.length += amount; }
    function set(uint index, uint value) public returns (bool) { data[index] = value; return true; }
    function get(uint index) public returns (uint) { return data[index]; }
    function length() public returns (uint) { return data.length; }
}
