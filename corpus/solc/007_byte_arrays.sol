contract C {
    function f(uint a, bytes memory b, uint c)
            public pure returns (uint, uint, byte, uint) {
        return (a, b.length, b[3], c);
    }

    function f_external(uint a, bytes calldata b, uint c)
            external pure returns (uint, uint, byte, uint) {
        return (a, b.length, b[3], c);
    }
}
