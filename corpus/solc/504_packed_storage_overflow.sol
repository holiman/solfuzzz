contract C {
    uint16 x = 0x1234;
    uint16 a = 0xffff;
    uint16 b;
    function f() public returns (uint, uint, uint, uint) {
        a++;
        uint c = b;
        delete b;
        a -= 2;
        return (x, c, b, a);
    }
}
