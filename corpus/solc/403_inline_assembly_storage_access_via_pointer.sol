contract C {
    struct Data { uint contents; }
    uint public separator;
    Data public a;
    uint public separator2;
    function f() public returns (bool) {
        Data storage x = a;
        uint off;
        assembly {
            sstore(x_slot, 7)
            off := x_offset
        }
        assert(off == 0);
        return true;
    }
}
