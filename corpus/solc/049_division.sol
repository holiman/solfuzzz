contract C {
    function f(int x, int y) public pure returns (int) {
        require(y != 0);
        return x / y;
    }
}
