contract c {
    uint[4][] a;
    uint[10][] b;
    uint[][] c;
    function test(uint[2][] calldata d) external returns (uint) {
        a = d;
        b = a;
        c = b;
        return c[1][1] | c[1][2] | c[1][3] | c[1][4];
    }
}
