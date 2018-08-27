    contract Receiver {
        uint public received;
        address public sender;
        uint public value;
        constructor() public payable {}
        function receive(uint256 x) public payable { received = x; sender = msg.sender; value = msg.value; }
    }
    contract Sender {
        uint public received;
        address public sender;
        uint public value;
        constructor() public payable {}
        function doSend(address rec) public payable
        {
            bytes4 signature = bytes4(bytes32(keccak256("receive(uint256)")));
            if (rec.delegatecall(abi.encodeWithSelector(signature, 23))) {}
        }
    }
