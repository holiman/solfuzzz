contract c {
    struct Data { uint x; uint y; }
    Data[] data1;
    Data[] data2;
    function test() public returns (uint x, uint y) {
        data1.length = 9;
        data1[8].x = 4;
        data1[8].y = 5;
        data2 = data1;
        x = data2[8].x;
        y = data2[8].y;
        data1.length = 0;
        data2 = data1;
    }
}
