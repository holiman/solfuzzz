contract test {
    function f(uint a) public returns (uint x) { x = --a ^ (a-- ^ (++a ^ a++)); }
}
