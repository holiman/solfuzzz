contract test {
    function f(uint256[] calldata seq) external pure returns (uint256) {
        uint i = 0;
        uint sum = 0;
        while (i < seq.length)
        {
            uint idx = i;
            if (idx >= 10) break;
            uint x = seq[idx];
            if (x >= 1000) {
                uint n = i + 1;
                i = n;
                continue;
            }
            else {
                uint y = sum + x;
                sum = y;
            }
            if (sum >= 500) return sum;
            i++;
        }
        return sum;
    }
}
