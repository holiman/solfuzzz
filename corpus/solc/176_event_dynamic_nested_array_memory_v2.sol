pragma experimental ABIEncoderV2;
contract C {
    event E(uint[][]);
    function createEvent(uint x) public {
        uint[][] memory arr = new uint[][](2);
        arr[0] = new uint[](2);
        arr[1] = new uint[](2);
        arr[0][0] = x;
        arr[0][1] = x + 1;
        arr[1][0] = x + 2;
        arr[1][1] = x + 3;
        emit E(arr);
    }
}
