contract c {
    function set() public returns (bool) { data = msg.data; return true; }
    function() external { data = msg.data; }
    bytes data;
}
