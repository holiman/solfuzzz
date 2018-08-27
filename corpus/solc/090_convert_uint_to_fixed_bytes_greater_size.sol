contract Test {
    function UintToBytes(uint16 h) public returns (bytes8 s) {
        return bytes8(uint64(h));
    }
}
