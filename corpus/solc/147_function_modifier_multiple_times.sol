contract C {
    uint public a;
    modifier mod(uint x) { a += x; _; }
    function f(uint x) mod(2) mod(5) mod(x) public returns(uint) { return a; }
}
