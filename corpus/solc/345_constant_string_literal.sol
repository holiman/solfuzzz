contract Test {
    bytes32 constant public b = "abcdefghijklmnopq";
    string constant public x = "abefghijklmnopqabcdefghijklmnopqabcdefghijklmnopqabca";

    constructor() public {
        string memory xx = x;
        bytes32 bb = b;
    }
    function getB() public returns (bytes32) { return b; }
    function getX() public returns (string memory) { return x; }
    function getX2() public returns (string memory r) { r = x; }
    function unused() public returns (uint) {
        "unusedunusedunusedunusedunusedunusedunusedunusedunusedunusedunusedunused";
        return 2;
    }
}
