contract C {
    function() internal returns (uint) x;
    int mutex;
    function t() public returns (uint) {
        if (mutex > 0)
            { assembly { mstore(0, 7) return(0, 0x20) } }
        mutex = 1;
        // Avoid re-executing this function if we jump somewhere.
        x();
        return 2;
    }
}
