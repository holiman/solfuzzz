contract test {
    function run(uint x1, uint x2, uint x3) public returns(uint y) {
        uint8 a = 0x1; uint8 b = 0x10; uint16 c = 0x100;
        y = a + b + c + x1 + x2 + x3;
        y += b + x2;
    }
}
