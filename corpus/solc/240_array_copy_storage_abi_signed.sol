contract c {
    int16[] x;
    function test() public returns (int16[] memory) {
        x.push(int16(-1));
        x.push(int16(-1));
        x.push(int16(8));
        x.push(int16(-16));
        x.push(int16(-2));
        x.push(int16(6));
        x.push(int16(8));
        x.push(int16(-1));
        return x;
    }
}
