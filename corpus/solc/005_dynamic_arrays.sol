contract C {
    function f(uint a, uint16[] memory b, uint c)
            public pure returns (uint, uint, uint) {
        return (b.length, b[a], c);
    }
}
