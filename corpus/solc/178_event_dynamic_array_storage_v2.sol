pragma experimental ABIEncoderV2;
contract C {
    event E(uint[]);
    uint[] arr;
    function createEvent(uint x) public {
        arr.length = 3;
        arr[0] = x;
        arr[1] = x + 1;
        arr[2] = x + 2;
        emit E(arr);
    }
}
