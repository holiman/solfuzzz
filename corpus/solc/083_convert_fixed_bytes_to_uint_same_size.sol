contract Test {
    function bytesToUint(bytes32 s) public returns (uint256 h) {
        return uint(s);
    }
}
