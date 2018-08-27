contract Test {
    function bytesToUint(bytes4 s) public returns (uint16 h) {
        return uint16(uint32(s));
    }
}
