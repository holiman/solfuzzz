contract test {
    function f(bool cond, uint v) public returns (uint a, uint b) {
        cond ? a = v : b = v;
    }
}
