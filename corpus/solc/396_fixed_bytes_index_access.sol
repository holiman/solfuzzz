contract C {
    bytes16[] public data;
    function f(bytes32 x) public returns (byte) {
        return x[2];
    }
    function g(bytes32 x) public returns (uint) {
        data = [x[0], x[1], x[2]];
        data[0] = "12345";
        return uint(uint8(data[0][4]));
    }
}
