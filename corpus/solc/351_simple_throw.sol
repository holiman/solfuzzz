contract Test {
    function f(uint x) public returns (uint) {
        if (x > 10)
            return x + 10;
        else
            revert();
        return 2;
    }
}
