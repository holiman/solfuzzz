contract C {
    function f(uint x) public pure {
        x = 2;
        while (x > 1) {
            x = 2;
        }
        assert(x == 2);
    }
}
