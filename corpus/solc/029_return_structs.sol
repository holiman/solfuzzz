pragma experimental ABIEncoderV2;
contract C {
    struct S { uint a; T[] sub; }
    struct T { uint[2] x; }
    function f() public returns (uint x, S memory s) {
    }
}
