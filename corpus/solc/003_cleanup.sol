contract C {
    function f(uint16 a, int16 b, address c, bytes3 d, bool e)
            public pure returns (uint v, uint w, uint x, uint y, uint z) {
        assembly { v := a  w := b x := c y := d z := e}
    }
}
