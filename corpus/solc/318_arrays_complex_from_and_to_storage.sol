contract Test {
    uint24[3][] public data;
    function set(uint24[3][] memory _data) public returns (uint) {
        data = _data;
        return data.length;
    }
    function get() public returns (uint24[3][] memory) {
        return data;
    }
}
