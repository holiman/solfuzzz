pragma experimental ABIEncoderV2;
library L {
    struct S { uint a; T[] sub; bytes b; }
    struct T { uint[2] x; }
    function f(L.S storage s) public {}
    function g(L.S memory s) public {}
}
