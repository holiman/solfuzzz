contract C {
    event E(uint a, bytes[] b, uint c);
    function f() public {
        bytes[] memory x = new bytes[](2);
        x[0] = "000000000000000000000000000000000000000000000000000000000000000000";
        x[1] = "000000000000000000000000000000000000000000000000000000000000000";
        emit E(10, x, 10);
    }
}
