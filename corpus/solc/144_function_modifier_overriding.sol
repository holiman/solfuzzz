contract A {
    function f() mod public returns (bool r) { return true; }
    modifier mod { _; }
}
contract C is A {
    modifier mod { if (false) _; }
}
