contract C {
    function f() public returns (uint a) {
        a = 0x42;
        a <<= 8;
    }
}
