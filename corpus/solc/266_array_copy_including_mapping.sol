contract c {
    mapping(uint=>uint)[90][] large;
    mapping(uint=>uint)[3][] small;
    function test() public returns (uint r) {
        large.length = small.length = 7;
        large[3][2][0] = 2;
        large[1] = large[3];
        small[3][2][0] = 2;
        small[1] = small[2];
        r = ((
            small[3][2][0] * 0x100 |
            small[1][2][0]) * 0x100 |
            large[3][2][0]) * 0x100 |
            large[1][2][0];
        delete small;
        delete large;
    }
    function clear() public returns (uint r) {
        large.length = small.length = 7;
        small[3][2][0] = 0;
        large[3][2][0] = 0;
        small.length = large.length = 0;
        return 7;
    }
}
