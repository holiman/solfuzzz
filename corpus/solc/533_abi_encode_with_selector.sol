contract C {
    function f0() public pure returns (bytes memory) {
        return abi.encodeWithSelector(0x12345678);
    }
    function f1() public pure returns (bytes memory) {
        return abi.encodeWithSelector(0x12345678, "abc");
    }
    function f2() public pure returns (bytes memory) {
        bytes4 x = 0x12345678;
        return abi.encodeWithSelector(x, "abc");
    }
    function f3() public pure returns (bytes memory) {
        bytes4 x = 0x12345678;
        return abi.encodeWithSelector(x, uint(-1));
    }
}
