contract receiver {
    uint public calledLength;
    function() external { calledLength = msg.data.length; }
}
contract sender {
    receiver rec;
    constructor() public { rec = new receiver(); }
    function viaCalldata() public returns (uint) {
        require(address(rec).call(msg.data));
        return rec.calledLength();
    }
    function viaMemory() public returns (uint) {
        bytes memory x = msg.data;
        require(address(rec).call(x));
        return rec.calledLength();
    }
    bytes s;
    function viaStorage() public returns (uint) {
        s = msg.data;
        require(address(rec).call(s));
        return rec.calledLength();
    }
}
