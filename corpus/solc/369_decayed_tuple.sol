contract C {
    function f() public returns (uint) {
        uint x = 1;
        (x) = 2;
        return x;
    }
}
