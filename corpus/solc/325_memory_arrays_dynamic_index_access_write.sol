contract Test {
    uint24[3][][4] data;
    function set(uint24[3][][4] memory x) internal returns (uint24[3][][4] memory) {
        x[1][2][2] = 1;
        x[1][3][2] = 7;
        return x;
    }
    function f() public returns (uint24[3][] memory) {
        data[1].length = 4;
        return set(data)[1];
    }
}
