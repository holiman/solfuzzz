contract C {
    function f(uint x) public pure {
        uint a = 3;
        if (x > 10) {
            assert(a == 3);
        } else {
            assert(a == 3);
        }
        assert(a == 3);
    }
}
