contract C {
    function f() public returns (uint a) {
        a = 0x4200;
        a >>= 8;
    }
}
