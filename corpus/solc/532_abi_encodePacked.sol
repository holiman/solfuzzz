contract C {
    function f0() public pure returns (bytes memory) {
        return abi.encodePacked();
    }
    function f1() public pure returns (bytes memory) {
        return abi.encodePacked(uint8(1), uint8(2));
    }
    function f2() public pure returns (bytes memory) {
        string memory x = "abc";
        return abi.encodePacked(uint8(1), x, uint8(2));
    }
    function f3() public pure returns (bytes memory r) {
        // test that memory is properly allocated
        string memory x = "abc";
        r = abi.encodePacked(uint8(1), x, uint8(2));
        bytes memory y = "def";
        require(y[0] == "d");
        y[0] = "e";
        require(y[0] == "e");
    }
}
