contract c {
    function test(uint[8] calldata a, uint[] calldata b, uint[5] calldata c, uint a_index, uint b_index, uint c_index)
            external returns (uint av, uint bv, uint cv) {
        av = a[a_index];
        bv = b[b_index];
        cv = c[c_index];
    }
}
