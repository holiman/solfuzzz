contract receiver {
    uint public received;
    function receive(uint x) public { received += x + 1; }
    function() external { received = 0x80; }
}
contract sender {
    constructor() public { rec = new receiver(); }
    function() external { savedData1 = savedData2 = msg.data; }
    function forward(bool selector) public returns (bool) {
        if (selector) { address(rec).call(savedData1); delete savedData1; }
        else { address(rec).call(savedData2); delete savedData2; }
        return true;
    }
    function val() public returns (uint) { return rec.received(); }
    receiver rec;
    bytes savedData1;
    bytes savedData2;
}
