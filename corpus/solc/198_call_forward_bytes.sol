contract receiver {
    uint public received;
    function receive(uint x) public { received += x + 1; }
    function() external { received = 0x80; }
}
contract sender {
    constructor() public { rec = new receiver(); }
    function() external { savedData = msg.data; }
    function forward() public returns (bool) { !address(rec).call(savedData); return true; }
    function clear() public returns (bool) { delete savedData; return true; }
    function val() public returns (uint) { return rec.received(); }
    receiver rec;
    bytes savedData;
}
