contract C {
    function f(uint x, uint y) public pure {
        x = 7;
        while ((x = y) > 0) {
        }
        assert(x == 7);
    }
}
