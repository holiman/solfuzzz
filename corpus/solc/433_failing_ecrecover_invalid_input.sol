contract C {
    function f() public returns (address) {
        return ecrecover(bytes32(uint(-1)), 1, bytes32(uint(2)), bytes32(uint(3)));
    }
}
