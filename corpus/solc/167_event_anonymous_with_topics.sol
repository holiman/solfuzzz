contract ClientReceipt {
    event Deposit(address indexed _from, bytes32 indexed _id, uint indexed _value, uint indexed _value2, bytes32 data) anonymous;
    function deposit(bytes32 _id) public payable {
        emit Deposit(msg.sender, _id, msg.value, 2, "abc");
    }
}
