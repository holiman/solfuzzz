contract A {
    uint data;
    constructor() mod1 public { f1(); }
    function f1() mod2 public { data |= 0x1; }
    function f2() public { data |= 0x20; }
    function f3() public { }
    modifier mod1 { f2(); _; }
    modifier mod2 { f3(); if (false) _; }
    function getData() public returns (uint r) { return data; }
}
contract C is A {
    modifier mod1 { f4(); _; }
    function f3() public { data |= 0x300; }
    function f4() public { data |= 0x4000; }
}
