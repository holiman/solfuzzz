contract A {
    function g(uint x) public returns (uint) {
        return x ** 0x100;
    }
    function h(uint x) public returns (uint) {
        return x ** 0x10000;
    }
}
